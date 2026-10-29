-----------------------------------------------------------------------------------------------------------------------------------------
-- CAIXAS ELETRÔNICOS (painel gestor) - salvos em data/atms.json
-- Usados pelo bank (opções Abrir/Roubar) e pelo c4 (roubo com C4)
-----------------------------------------------------------------------------------------------------------------------------------------
local AtmsVRP = module("vrp","lib/Proxy").getInterface("vRP")
local Resource = GetCurrentResourceName()
local File = "data/atms.json"
local Atms = {}
local Models = { prop_atm_01 = true, prop_atm_02 = true, prop_atm_03 = true, prop_fleeca_atm = true }
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOAD / SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
local function Load()
	Atms = Storage.Read(File)
end

local function Save()
	Storage.Write(File,Atms)
end

local function List()
	local Result = {}
	for _,Atm in pairs(Atms) do
		Result[#Result + 1] = Atm
	end

	table.sort(Result,function(a,b) return a.id < b.id end)

	return Result
end

-- Clientes (bank/c4) recebem pelo evento de rede; o c4 do servidor pelo evento local
local function Sync(Target)
	local Result = List()
	TriggerClientEvent("Night_Management:atmsSync",Target or -1,Result)

	if not Target then
		TriggerEvent("Night_Management:atmsChanged",Result)
	end
end

local function IsAdmin(Source)
	local Passport = AtmsVRP.Passport(Source)
	return Passport and AtmsVRP.HasPermission(Passport,Config.Permissions.Permission)
end

local function Hour(Value)
	Value = tonumber(Value)
	if not Value or Value < 0 or Value > 23 then
		return nil
	end

	return math.floor(Value)
end

Load()

exports("AtmList",List)

AddEventHandler("onResourceStart",function(Name)
	if Name == Resource then
		Sync()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Night_Management:atmsLoad")
AddEventHandler("Night_Management:atmsLoad",function()
	Sync(source)
end)

RegisterServerEvent("Night_Management:requestAtms")
AddEventHandler("Night_Management:requestAtms",function()
	local source = source
	if IsAdmin(source) then
		TriggerClientEvent("Night_Management:updateAtms",source,List())
	end
end)

RegisterServerEvent("Night_Management:saveAtm")
AddEventHandler("Night_Management:saveAtm",function(Data)
	local source = source
	if not IsAdmin(source) or type(Data) ~= "table" then
		return
	end

	local X,Y,Z = tonumber(Data.x),tonumber(Data.y),tonumber(Data.z)
	if not X or not Y or not Z then
		return
	end

	local Model = Models[Data.model] and Data.model or nil
	local Kind = Data.kind == "agency" and "agency" or "atm"
	local Rob = Kind == "atm" and Data.rob == true
	if Rob and not Model then
		TriggerClientEvent("Notify",source,"Atenção","Para liberar o roubo fique em frente ao caixa e clique em <b>Usar minha posição</b> para detectar o modelo.","amarelo",8000)
		return
	end

	local StartHour,EndHour = Hour(Data.startHour),Hour(Data.endHour)
	if not StartHour or not EndHour then
		StartHour,EndHour = nil,nil
	end

	local Id = tonumber(Data.id)
	if not Id or not Atms[tostring(Id)] then
		Id = 0
		for _,Atm in pairs(Atms) do
			if Atm.id > Id then Id = Atm.id end
		end
		Id = Id + 1
	end

	local Name = tostring(Data.name or ""):sub(1,60)
	Atms[tostring(Id)] = {
		id = Id,
        Kind = Kind,
		Name = Name ~= "" and Name or "ATM #"..Id,
		X = X, Y = Y, Z = Z,
		Model = Model,
		Open = Data.open and true or false,
		Rob = Rob,
		StartHour = StartHour,
		EndHour = EndHour
	}

	Save()
	Sync()
	TriggerClientEvent("Night_Management:updateAtms",source,List())
	TriggerClientEvent("Notify",source,"Sucesso","Ponto bancário <b>"..Atms[tostring(Id)].Name.."</b> salvo.","verde",5000)
end)

RegisterServerEvent("Night_Management:deleteAtm")
AddEventHandler("Night_Management:deleteAtm",function(Id)
	local source = source
	if not IsAdmin(source) or not Atms[tostring(Id)] then
		return
	end

	Atms[tostring(Id)] = nil

	Save()
	Sync()
	TriggerClientEvent("Night_Management:updateAtms",source,List())
end)
