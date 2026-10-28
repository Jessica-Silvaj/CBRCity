
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")

local Server = {}
Tunnel.bindInterface("detran-app",Server)

local function VehicleName(v)
	return exports.vrp:VehicleName(v)
end

local function VehiclePrice(v)
	return exports.vrp:VehiclePrice(v)
end

local function notify(source,kind,message)
	TriggerClientEvent("Notify",source,kind or "verde",message,5000)
end

local function identity(Passport)
	return vRP.Identity(parseInt(Passport)) or {}
end

local function fullName(Passport)
	local Identity = identity(Passport)
	return (Identity.name or Identity.Name or "Passaporte").." "..(Identity.name2 or Identity.Lastname or tostring(Passport))
end

local function licenseData(Passport)
	local Data = vRP.UserData(Passport,"autoescola_cnh")
	if type(Data) == "string" then
		local ok, parsed = pcall(json.decode, Data)
		if ok and parsed then Data = parsed end
	end
	if type(Data) ~= "table" then Data = {} end

	local Categories = {}
	for Key,Value in pairs(Data) do
		if type(Key) == "number" then
			Categories[tostring(Value)] = true
		elseif Value then
			Categories[tostring(Key)] = true
		end
	end

	local points = vRP.UserData(Passport, "autoescola_pontos")
	if points == nil or points == "" then points = 0 end
	
	local oldData = vRP.UserData(Passport, "Driverlicense")
	if type(oldData) == "string" then
		local ok, parsed = pcall(json.decode, oldData)
		if ok and parsed then oldData = parsed end
	end
	if type(oldData) ~= "table" then oldData = {} end
	
	local validadeData = vRP.UserData(Passport, "autoescola_validade")
	if type(validadeData) == "string" then
		local ok, parsed = pcall(json.decode, validadeData)
		if ok and parsed then validadeData = parsed end
	end
	if type(validadeData) ~= "table" then validadeData = {} end
	
	local validadeStr = nil
	for k, v in pairs(validadeData) do
		validadeStr = v
		break
	end
	
	local t = os.date("*t")
	local createdAtTime = os.time({day=t.day, month=t.month, year=t.year+10, hour=12, min=0, sec=0})
	
	if validadeStr then
		local d, m, y = string.match(validadeStr, "(%d+)/(%d+)/(%d+)")
		if d and m and y then
			createdAtTime = os.time({day=tonumber(d), month=tonumber(m), year=tonumber(y), hour=12, min=0, sec=0})
		end
	end
	
	return Categories, parseInt(points), parseInt(createdAtTime)
end

vRP.Prepare("detran/getVehicleByPlate", "SELECT * FROM vehicles WHERE plate = @plate")

local function vehicleByPlate(plate)
	local Result = vRP.Query("detran/getVehicleByPlate",{ plate = tostring(plate or "") })
	return Result and Result[1]
end

local function vehiclePayload(row)
	if not row then
		return false
	end

	local vehModel = row.vehicle or row.Vehicle
	local vehPlate = row.plate or row.Plate
	local Tax = parseInt(row.tax or row.Tax or 0)
	local Seized = parseInt(row.arrest or row.Arrest or row.seized or row.Seized or 0)
	local IsSeized = Seized > os.time()

	return {
		model = exports.vrp:VehicleName(vehModel) or vehModel,
		name = exports.vrp:VehicleName(vehModel) or vehModel,
		vehicle = vehModel,
		plate = vehPlate,
		tax = Tax,
		seized = IsSeized and 1 or 0,
		isLate = Tax > 0 and Tax < os.time(),
		isSeized = IsSeized
	}
end

local function response(status,plate,errorMessage)
	if status then
		return { status = "success", data = Server.getVehicle(plate) }
	end

	return { status = "error", error = errorMessage or "Nao foi possivel concluir." }
end

function Server.getData()
	local Passport = vRP.Passport(source)
	if not Passport then
		return { id = 0, name = "", categories = {} }
	end

	local Identity = identity(Passport)
	local Categories,Points,CreatedAt = licenseData(Passport)

	return {
		id = Passport,
		name = fullName(Passport),
		sex = Identity.sex == "F" and "Feminino" or "Masculino",
		categories = Categories,
		licensePoints = Points,
		createdAt = CreatedAt
	}
end

function Server.getVehicles()
	local Passport = vRP.Passport(source)
	local Vehicles = {}
	if not Passport then
		return Vehicles
	end

	for _,Row in pairs(vRP.Query("vehicles/UserVehicles",{ Passport = Passport }) or {}) do
		local vehName = Row.Vehicle or Row.vehicle
		if not Row.Work and not Row.work and exports.vrp:VehicleExist(vehName) then
			Vehicles[#Vehicles + 1] = vehiclePayload(Row)
		end
	end

	return Vehicles
end

function Server.getVehicle(plate)
	local Passport = vRP.Passport(source)
	local Row = vehicleByPlate(plate)
	if not Passport or not Row or parseInt(Row.Passport or Row.passport) ~= parseInt(Passport) then
		return false
	end

	return vehiclePayload(Row)
end

function Server.payTax(plate)
	local source = source
	local Passport = vRP.Passport(source)
	local Row = vehicleByPlate(plate)
	if not Passport or not Row or parseInt(Row.Passport or Row.passport) ~= parseInt(Passport) then
		return response(false,plate,"Veiculo nao encontrado.")
	end

	local tax = parseInt(Row.tax or Row.Tax or 0)
	if tax > os.time() then
		return response(false,plate,"Licenciamento ainda esta em dia.")
	end

	local vehModel = Row.vehicle or Row.Vehicle
	local Price = parseInt((VehiclePrice(vehModel) or 0) * 0.10)
	if Price <= 0 then
		Price = 5000
	end

	if vRP.PaymentFull(Passport,Price,"Detran") then
		vRP.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = vehModel })
		notify(source,"verde","Licenciamento renovado.")
		return response(true,plate)
	end

	return response(false,plate,"Saldo insuficiente.")
end

function Server.payImpound(plate)
	local source = source
	local Passport = vRP.Passport(source)
	local Row = vehicleByPlate(plate)
	if not Passport or not Row or parseInt(Row.Passport or Row.passport) ~= parseInt(Passport) then
		return response(false,plate,"Veiculo nao encontrado.")
	end

	local arrest = parseInt(Row.arrest or Row.Arrest or Row.seized or Row.Seized or 0)
	if arrest <= os.time() then
		return response(false,plate,"Veiculo nao esta apreendido.")
	end

	local vehModel = Row.vehicle or Row.Vehicle
	local Price = parseInt((VehiclePrice(vehModel) or 0) * 0.15)
	if Price <= 0 then
		Price = 7500
	end

	if vRP.PaymentFull(Passport,Price,"Detran") then
		vRP.Query("vehicles/paymentArrest",{ Passport = Passport, vehicle = vehModel })
		notify(source,"verde","Veiculo liberado.")
		return response(true,plate)
	end

	return response(false,plate,"Saldo insuficiente.")
end