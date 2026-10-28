local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())


Config = module(GetCurrentResourceName(), "config/config")

vRP.Prepare("night/initial", [[
    CREATE TABLE IF NOT EXISTS initial(
        user_id INTEGER,
		resgatou INTEGER,
        PRIMARY KEY (`user_id`) USING BTREE
    )
]])

vRP.Prepare("night/initial_data", [[
    CREATE TABLE IF NOT EXISTS initial_data(
        user_id INTEGER,
		carro LONGTEXT,
	    tempo INTEGER,
        PRIMARY KEY (`user_id`) USING BTREE
    )
]])

Citizen.CreateThread(function()
    vRP.Query("night/initial")
    vRP.Query("night/initial_data")
end)

vRP.Prepare("initial/inserir_resgate", "INSERT INTO initial(user_id, resgatou) VALUES(@user_id,@resgatou)")
vRP.Prepare("initial/ver_resgate","SELECT * FROM initial WHERE user_id = @user_id")
vRP.Prepare("initial/update", "UPDATE initial SET resgatou = @resgatou WHERE user_id = @user_id") 
vRP.Prepare("night/getCarro", "SELECT * FROM initial_data WHERE user_id = @user_id") 
vRP.Prepare("night/insertCarro", "INSERT INTO initial_data(user_id,carro,tempo) VALUES(@user_id,@carro,@tempo)")
vRP.Prepare("night/deleteCarro","DELETE FROM initial_data WHERE user_id = @user_id")

local function vehicleName(veh)
    return exports["vrp"]:VehicleName(veh) or veh
end

src.verificarResgate = function()
    local source = source
    local user_id = vRP.Passport(source)
	if user_id then
		local info = vRP.Query("initial/ver_resgate", {user_id = user_id})
		if not info[1] then
			vRP.Query("initial/inserir_resgate", {user_id = user_id,resgatou = 0})
		end
		local info = vRP.Query("initial/ver_resgate", {user_id = user_id})
		if parseInt(info[1].resgatou) == 0 then
			return true
		else
			return false
		end
	end
end

function calculaExpireTime(dias)
    local stimer = parseInt(os.time()+(24*dias*60*60))
    return stimer
end

-- Entrega automatica do veiculo inicial (sem menu / sem /resgatar), uma unica vez por passaporte
local function EntregarVeiculoInicial(user_id,source)
    local carro = Config.VeiculoInicial
    if not carro or not exports["vrp"]:VehicleExist(carro) then
        return
    end

    local info = vRP.Query("initial/ver_resgate", {user_id = user_id})
    if not info[1] then
        vRP.Query("initial/inserir_resgate", {user_id = user_id,resgatou = 0})
        info = vRP.Query("initial/ver_resgate", {user_id = user_id})
    end

    if parseInt(info[1].resgatou) ~= 0 then
        return
    end

    vRP.Query("initial/update", {user_id = user_id,resgatou = 1})

    if not vRP.SelectVehicle(user_id,carro) then
        vRP.Query("vehicles/addVehicles", {
            Passport = user_id,
            Vehicle = carro,
            Plate = vRP.GeneratePlate(),
            Weight = 0,
            Work = "false"
        })
    end

    TriggerClientEvent("Notify",source,"Sucesso","Você recebeu sua <b>"..vehicleName(carro).."</b> inicial. Retire na garagem.","verde",10000)

    if Config.Webhook and Config.Webhook ~= "" then
        local identity = vRP.Identity(user_id)
        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    description = "# VEICULO INICIAL",
                    fields = {
                        {
                            name = "👤 AUTHOR",
                            value = "" ..(identity and identity.Name or "").." "..(identity and identity.Lastname or "").." **#"..user_id.."** ",
                        },
                        {
                            name = "🚗 CARRO",
                            value = ""..vehicleName(carro).." ("..carro..")",
                        },
                    },
                    footer = {
                        text = os.date('Dia: %d/%m/%Y - Horas: %H:%M:%S')
                    },
                    color = 2829875
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end

AddEventHandler("Connect",function(Passport,source)
    EntregarVeiculoInicial(Passport,source)
end)

function diasRestantes(expireTime)
    local segundosRestantes = expireTime - os.time()
    local diasRestantes = math.floor(segundosRestantes / (24 * 60 * 60))
    return diasRestantes
end

src.verificar_resgate = function()
    local source = source
    local user_id = vRP.Passport(source)
    local identity = vRP.Identity(user_id)
    if user_id then
        local GetJogador = vRP.Query("night/getCarro", {user_id = user_id})
        if GetJogador[1] then
            if GetJogador[1].tempo < os.time() then
                vRP.Query("vehicles/removeVehicles", {Passport = parseInt(user_id),Vehicle = GetJogador[1].carro})
                vRP.Query("night/deleteCarro", {user_id = user_id})
            else
                local diasRestantes = diasRestantes(GetJogador[1].tempo)
            end
        end
    end
end