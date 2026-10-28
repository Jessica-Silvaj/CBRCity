local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Server = {}
Tunnel.bindInterface(GetCurrentResourceName(),Server)

local dataKey = "lb-phone-rifa:Data"
local state = vRP.GetSrvData(dataKey,true)
state.raffles = state.raffles or {}
state.winners = state.winners or {}
state.nextId = state.nextId or 0

local function save()
	vRP.SetSrvData(dataKey,state,true)
end

local function fullName(Passport)
	local Identity = vRP.Identity(Passport) or {}
	return (Identity.name or Identity.Name or "Passaporte").." "..(Identity.name2 or Identity.Lastname or tostring(Passport))
end

local function vehicleByPlate(plate)
	local result = vRP.Query("vehicles/plateVehicles",{ Plate = tostring(plate or "") })
	return result and result[1]
end

local function raffleList()
	local list = {}
	for _,raffle in pairs(state.raffles) do
		list[#list + 1] = raffle
	end
	table.sort(list,function(a,b) return a.id < b.id end)
	return list
end

function Server.loadData()
	local Passport = vRP.Passport(source)
	return {
		active = raffleList(),
		user = {
			id = Passport,
			name = Passport and fullName(Passport) or ""
		}
	}
end

function Server.GetVehicles()
	local Passport = vRP.Passport(source)
	local list = {}
	if not Passport then
		return list
	end

	for _,row in pairs(vRP.Query("vehicles/UserVehicles",{ Passport = Passport }) or {}) do
		local vehName = row.vehicle or row.Vehicle
		local vehWork = row.work or row.Work
		
		if exports.vrp:VehicleExist(vehName) and not vehWork then
			list[#list + 1] = {
				model = vehName,
				name = exports.vrp:VehicleName(vehName) or vehName,
				plate = row.plate or row.Plate,
				status = "Regular",
				canRaffle = true
			}
		end
	end

	return list
end

function Server.createRaffle(payload)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or type(payload) ~= "table" then
		return false
	end

	local plate = tostring(payload.plate or "")
	local row = vehicleByPlate(plate)
	if not row or parseInt(row.Passport) ~= parseInt(Passport) then
		TriggerClientEvent("Notify",source,"vermelho","Veiculo invalido.",5000)
		return false
	end

	state.nextId = parseInt(state.nextId) + 1
	state.raffles[tostring(state.nextId)] = {
		id = state.nextId,
		passport = Passport,
		owner = Passport,
		vehicle = row.vehicle or row.Vehicle,
		vehicle_name = payload.name or exports.vrp:VehicleName(row.vehicle or row.Vehicle) or (row.vehicle or row.Vehicle),
		plate = row.plate or row.Plate,
		image_url = (payload.image and payload.image ~= "") and payload.image or ("nui://garages/web-side/vehicles/" .. (row.vehicle or row.Vehicle) .. ".png"),
		price = parseInt(payload.price),
		total_tickets = math.max(1,parseInt(payload.total)),
		sold_tickets = 0,
		tickets = {},
		created_at = os.date("%d/%m/%Y")
	}

	save()
	return true
end

function Server.buyTicket(payload)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or type(payload) ~= "table" then
		return { success = false, msg = "Usuario invalido." }
	end

	local raffle = state.raffles[tostring(payload.id)]
	if not raffle then
		return { success = false, msg = "Rifa indisponivel." }
	end

	if parseInt(raffle.owner) == parseInt(Passport) then
		return { success = false, msg = "Voce nao pode comprar cotas da sua propria rifa." }
	end

	local quantity = math.max(1,parseInt(payload.quantity or 1))
	local free = {}
	local used = {}
	for _,ticket in ipairs(raffle.tickets) do
		used[parseInt(ticket.number)] = true
	end
	for number = 1,parseInt(raffle.total_tickets) do
		if not used[number] then
			free[#free + 1] = number
		end
	end

	if #free < quantity then
		return { success = false, msg = "Cotas insuficientes." }
	end

	local total = parseInt(raffle.price) * quantity
	if not vRP.PaymentFull(Passport,total,"Rifa") then
		return { success = false, msg = "Pagamento recusado." }
	end

	local numbers = {}
	for i = 1,quantity do
		local number = table.remove(free,math.random(#free))
		numbers[#numbers + 1] = number
		raffle.tickets[#raffle.tickets + 1] = {
			passport = Passport,
			number = number,
			status = "paid"
		}
	end
	raffle.sold_tickets = #raffle.tickets

	if raffle.sold_tickets >= parseInt(raffle.total_tickets) then
		local winnerTicket = raffle.tickets[math.random(#raffle.tickets)]
		local row = vehicleByPlate(raffle.plate)
		if row then
			if vRP.Update then
				vRP.Update("vehicles/moveVehicles",{ Passport = raffle.owner, OtherPassport = winnerTicket.passport, Vehicle = raffle.vehicle })
			else
				vRP.Query("vehicles/moveVehicles",{ Passport = raffle.owner, OtherPassport = winnerTicket.passport, Vehicle = raffle.vehicle })
			end
		end
		vRP.GiveBank(raffle.owner,parseInt(raffle.price) * parseInt(raffle.total_tickets))
		TriggerClientEvent("Notify", -1, "amarelo", "O jogador <b>"..fullName(winnerTicket.passport).."</b> acaba de ganhar um(a) <b>"..raffle.vehicle_name.."</b> na rifa!", 10000)
		state.winners[#state.winners + 1] = {
			id = raffle.id,
			name = raffle.vehicle_name,
			vehicle_name = raffle.vehicle_name,
			plate = raffle.plate,
			image_url = raffle.image_url,
			passport = winnerTicket.passport,
			winner_name = fullName(winnerTicket.passport),
			winner_number = winnerTicket.number,
			date = os.date("%d/%m/%Y")
		}
		state.raffles[tostring(raffle.id)] = nil
	end

	save()
	return { success = true, msg = "Compra aprovada.", numbers = numbers }
end

function Server.getWinners()
	return state.winners
end

function Server.getMyTickets()
	local Passport = vRP.Passport(source)
	local list = {}
	if not Passport then
		return list
	end

	for _,raffle in pairs(state.raffles) do
		for _,ticket in ipairs(raffle.tickets or {}) do
			if parseInt(ticket.passport) == parseInt(Passport) then
				list[#list + 1] = {
					raffle_id = raffle.id,
					number = ticket.number,
					status = ticket.status,
					vehicle_name = raffle.vehicle_name,
					plate = raffle.plate,
					image_url = raffle.image_url
				}
			end
		end
	end
	return list
end
