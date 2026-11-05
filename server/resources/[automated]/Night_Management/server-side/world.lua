----------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS, TELEPORTS E NOMES DE RUAS (painel gestor)
-- Salvos pelo Storage (tabela night_management). O creative aplica no cliente via Night_Management:worldSync.
----------------------------------------------------------------------------------------------------------------------------------
local WorldVRP = module("vrp","lib/Proxy").getInterface("vRP")
local Collections = {
	Alphas = { File = "data/alphas.json", Update = "updateAlphas", Saved = "alphaSaved" },
	Teleports = { File = "data/teleports.json", Update = "updateTeleports", Saved = "teleportSaved" },
	Streets = { File = "data/streets.json", Update = "updateStreets", Saved = "streetSaved" }
}
local Loaded = false

local function Ensure()
	if Loaded then
		return
	end

	for _,Collection in pairs(Collections) do
		Collection.Data = Storage.Read(Collection.File)
	end

	Loaded = true
end

local function List(Collection)
	Ensure()

	local Result = {}
	for _,Row in pairs(Collection.Data) do
		Result[#Result + 1] = Row
	end

	table.sort(Result,function(a,b) return a.id < b.id end)

	return Result
end

local function Sync(Target)
	TriggerClientEvent("Night_Management:worldSync",Target or -1,List(Collections.Alphas),List(Collections.Teleports),List(Collections.Streets))
end

local function IsAdmin(Source)
	local Passport = WorldVRP.Passport(Source)
	return Passport and WorldVRP.HasPermission(Passport,Config.Permissions.Permission)
end

local function Text(Value,Limit)
	if type(Value) ~= "string" then
		return nil
	end

	Value = Value:gsub("^%s+",""):gsub("%s+$","")
	if Value == "" or #Value > Limit then
		return nil
	end

	return Value
end

local function Clamp(Value,Min,Max,Default)
	Value = tonumber(Value) or Default
	return math.floor(math.max(Min,math.min(Max,Value)))
end

local function NextId(Collection,Requested)
	local Id = tonumber(Requested)
	if Id and Collection.Data[tostring(Id)] then
		return Id
	end

	Id = 0
	for _,Row in pairs(Collection.Data) do
		if Row.id > Id then
			Id = Row.id
		end
	end

	return Id + 1
end

local Builders = {
	Alphas = function(Data)
		local Name = Text(Data.name,100)
		local X,Y,Z = tonumber(Data.x),tonumber(Data.y),tonumber(Data.z)
		if not Name or not X or not Y or not Z then
			return nil
		end

		return { name = Name, x = X, y = Y, z = Z, radius = math.max(1.0,tonumber(Data.radius) or 100.0), color = Clamp(Data.color,0,255,53), alpha = Clamp(Data.alpha,0,255,100) }
	end,
	Teleports = function(Data)
		local Name = Text(Data.name,100)
		local X1,Y1,Z1 = tonumber(Data.x1),tonumber(Data.y1),tonumber(Data.z1)
		local X2,Y2,Z2 = tonumber(Data.x2),tonumber(Data.y2),tonumber(Data.z2)
		if not Name or not X1 or not Y1 or not Z1 or not X2 or not Y2 or not Z2 then
			return nil
		end

		return { name = Name, x1 = X1, y1 = Y1, z1 = Z1, x2 = X2, y2 = Y2, z2 = Z2 }
	end,
	Streets = function(Data)
		local Hash = Text(tostring(Data.hash or ""),50)
		local Name = Text(Data.name,150)
		if not Hash or not Name then
			return nil
		end

		return { hash = Hash, name = Name }
	end
}

local function Register(Key,RequestEvent,SaveEvent,DeleteEvent)
	local Collection = Collections[Key]

	RegisterServerEvent("Night_Management:"..RequestEvent)
	AddEventHandler("Night_Management:"..RequestEvent,function()
		local source = source
		if IsAdmin(source) then
			TriggerClientEvent("Night_Management:"..Collection.Update,source,List(Collection))
		end
	end)

	RegisterServerEvent("Night_Management:"..SaveEvent)
	AddEventHandler("Night_Management:"..SaveEvent,function(Data)
		local source = source
		if not IsAdmin(source) or type(Data) ~= "table" then
			return
		end

		local Row = Builders[Key](Data)
		if not Row then
			TriggerClientEvent("Notify",source,"Atenção","Preencha todos os campos corretamente.","amarelo",5000)
			return
		end

		Ensure()
		Row.id = NextId(Collection,Data.id)

		local Previous = Collection.Data[tostring(Row.id)]
		Collection.Data[tostring(Row.id)] = Row
		if not Storage.Write(Collection.File,Collection.Data) then
			Collection.Data[tostring(Row.id)] = Previous
			TriggerClientEvent("Notify",source,"Atenção","Não foi possível salvar no banco.","vermelho",5000)
			return
		end

		Sync()
		TriggerClientEvent("Night_Management:"..Collection.Saved,source)
		TriggerClientEvent("Night_Management:"..Collection.Update,source,List(Collection))
	end)

	RegisterServerEvent("Night_Management:"..DeleteEvent)
	AddEventHandler("Night_Management:"..DeleteEvent,function(Data)
		local source = source
		if not IsAdmin(source) or type(Data) ~= "table" then
			return
		end

		Ensure()
		local Id = tostring(tonumber(Data.id) or "")
		local Previous = Collection.Data[Id]
		if not Previous then
			return
		end

		Collection.Data[Id] = nil
		if not Storage.Write(Collection.File,Collection.Data) then
			Collection.Data[Id] = Previous
			TriggerClientEvent("Notify",source,"Atenção","Não foi possível salvar no banco.","vermelho",5000)
			return
		end

		Sync()
		TriggerClientEvent("Night_Management:"..Collection.Update,source,List(Collection))
	end)
end

Register("Alphas","requestAlphas","saveAlpha","deleteAlpha")
Register("Teleports","requestTeleports","saveTeleport","deleteTeleport")
Register("Streets","requestStreets","saveStreet","deleteStreet")

RegisterServerEvent("Night_Management:worldLoad")
AddEventHandler("Night_Management:worldLoad",function()
	Sync(source)
end)

AddEventHandler("onResourceStart",function(Name)
	if Name == GetCurrentResourceName() then
		CreateThread(function()
			Sync()
		end)
	end
end)
