-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPS DA CIDADE (painel gestor) - salvos em data/props.json
-----------------------------------------------------------------------------------------------------------------------------------------
local PropsVRP = module("vrp","lib/Proxy").getInterface("vRP")
local PropsVRPC = module("vrp","lib/Tunnel").getInterface("vRP")
local Resource = GetCurrentResourceName()
local File = "data/props.json"
local Props = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOAD / SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
local function Load()
	Props = Storage.Read(File)
end

local function Save()
	Storage.Write(File,Props)
end

local function List()
	local Result = {}
	for _,Prop in pairs(Props) do
		Result[#Result + 1] = Prop
	end

	table.sort(Result,function(a,b) return a.id < b.id end)

	return Result
end

local function Sync(Target)
	TriggerClientEvent("Night_Management:propsSync",Target or -1,List())
end

local function IsAdmin(Source)
	local Passport = PropsVRP.Passport(Source)
	return Passport and PropsVRP.HasPermission(Passport,Config.Permissions.Permission)
end

Load()
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Night_Management:propsLoad")
AddEventHandler("Night_Management:propsLoad",function()
	Sync(source)
end)

RegisterServerEvent("Night_Management:requestProps")
AddEventHandler("Night_Management:requestProps",function()
	local source = source
	if IsAdmin(source) then
		TriggerClientEvent("Night_Management:updateProps",source,List())
	end
end)

-- Mesma mecânica de mobiliar a casa (inventory/server-side/itens.lua): H posiciona, F cancela, Q/E giram, Z troca o modo
RegisterServerEvent("Night_Management:placeProp")
AddEventHandler("Night_Management:placeProp",function(Data)
	local source = source
	if not IsAdmin(source) or type(Data) ~= "table" then
		return
	end

	local Model = tostring(Data.model or "")
	if not Model:match("^[%w_%-]+$") then
		return
	end

	local Id = tonumber(Data.id)
	if Id and not Props[tostring(Id)] then
		Id = nil
	end

	Player(source).state.Buttons = true
	TriggerClientEvent("Night_Management:propsEditing",source,Id)

	local Application,Coords = PropsVRPC.ObjectControlling(source,Model)

	TriggerClientEvent("Night_Management:propsEditing",source,nil)
	Player(source).state.Buttons = false

	if not Application or not Coords then
		TriggerClientEvent("Notify",source,"Aviso","Posicionamento cancelado.","amarelo",5000)
		return
	end

	local X,Y,Z,H = tonumber(Coords[1]),tonumber(Coords[2]),tonumber(Coords[3]),tonumber(Coords[4])
	if not X or not Y or not Z or not H then
		return
	end

	if not Id or not Props[tostring(Id)] then
		Id = 0
		for _,Prop in pairs(Props) do
			if Prop.id > Id then Id = Prop.id end
		end
		Id = Id + 1
	end

	Props[tostring(Id)] = {
		id = Id,
		Name = tostring(Data.name or Model):sub(1,60),
		Model = Model,
		X = X, Y = Y, Z = Z, H = H,
		Distance = math.max(10,math.min(tonumber(Data.distance) or 100,500)),
		Collision = Data.collision and true or false
	}

	Save()
	Sync()
	TriggerClientEvent("Notify",source,"Sucesso","Prop <b>"..Props[tostring(Id)].Name.."</b> salvo.","verde",5000)
end)

RegisterServerEvent("Night_Management:deleteProp")
AddEventHandler("Night_Management:deleteProp",function(Id)
	local source = source
	if not IsAdmin(source) or not Props[tostring(Id)] then
		return
	end

	Props[tostring(Id)] = nil

	Save()
	Sync()
	TriggerClientEvent("Night_Management:updateProps",source,List())
end)
