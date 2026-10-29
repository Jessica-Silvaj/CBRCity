-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = module("vrp","lib/Proxy").getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tanks = {}
local Equipped = {}
local LastPuff = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(source,Message,Color)
	TriggerClientEvent("Notify",source,"Vape",Message,Color or "amarelo",5000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TANK
-----------------------------------------------------------------------------------------------------------------------------------------
local function Tank(Passport)
	if not Tanks[Passport] then
		local Data = vRP.UserData(Passport,"NightVape")
		Tanks[Passport] = {
			Ml = type(Data) == "table" and tonumber(Data.Ml) or 0.0,
			Flavor = type(Data) == "table" and Config.Flavors[Data.Flavor] and Data.Flavor or nil
		}
	end

	return Tanks[Passport]
end

local function SaveTank(Passport)
	local Data = Tanks[Passport]
	if Data then
		vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "NightVape", Information = json.encode({ Ml = Data.Ml, Flavor = Data.Flavor }) })
	end
end

local function SyncTank(source,Passport)
	local Data = Tank(Passport)
	local Flavor = Data.Flavor and Config.Flavors[Data.Flavor]
	TriggerClientEvent("Night_Vape:Tank",source,Data.Ml,Config.Capacity,Flavor and Flavor.Name or nil)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE: chamado pelo inventory ao usar o item vape
-----------------------------------------------------------------------------------------------------------------------------------------
local function Toggle(source,Passport)
	if Equipped[source] then
		Equipped[source] = nil
		TriggerClientEvent("Night_Vape:Equip",source,false)
		return
	end

	local State = Player(source).state
	if State.Death or State.Crawl or State.Handcuff then
		return
	end

	Equipped[source] = Passport
	SyncTank(source,Passport)
	TriggerClientEvent("Night_Vape:Equip",source,true)

	if Tank(Passport).Ml < Config.PerPuff then
		Notify(source,"O tanque está vazio. Use um líquido para recarregar.")
	end
end
exports("Toggle",Toggle)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REFILL: chamado pelo inventory ao usar um líquido
-----------------------------------------------------------------------------------------------------------------------------------------
local function Refill(source,Passport,Item,Full,Slot)
	local Flavor = Config.Flavors[Item]
	if not Flavor then
		return false
	end

	if not vRP.ConsultItem(Passport,Config.Item,1) then
		Notify(source,"Você precisa de um vape para usar o líquido.")
		return false
	end

	local Data = Tank(Passport)
	if Data.Flavor == Item and Data.Ml >= Config.Capacity then
		Notify(source,"O tanque já está cheio.")
		return false
	end

	if not vRP.TakeItem(Passport,Full,1,true,Slot) then
		return false
	end

	-- Trocar de sabor descarta o que sobrou no tanque
	if Data.Flavor ~= Item then
		Data.Ml = 0.0
	end

	Data.Flavor = Item
	Data.Ml = math.min(Config.Capacity,Data.Ml + Config.BottleSize)
	SaveTank(Passport)

	TriggerClientEvent("inventory:Close",source)
	TriggerClientEvent("Night_Vape:Refill",source)
	SyncTank(source,Passport)
	Notify(source,"Tanque recarregado com "..Flavor.Name.." ("..string.format("%.1f",Data.Ml).." ml).","verde")

	return true
end
exports("Refill",Refill)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIQUIDS: o inventory registra estes itens como usáveis
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Liquids",function()
	local List = {}
	for Item in pairs(Config.Flavors) do
		List[#List + 1] = Item
	end

	return List
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUFF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Vape:Puff",function()
	local source = source
	local Passport = Equipped[source]
	if not Passport or vRP.Passport(source) ~= Passport then
		return
	end

	if LastPuff[source] and os.time() - LastPuff[source] < Config.PuffCooldown then
		return
	end

	if not vRP.ConsultItem(Passport,Config.Item,1) then
		Equipped[source] = nil
		TriggerClientEvent("Night_Vape:Equip",source,false)
		return
	end

	local Data = Tank(Passport)
	if not Data.Flavor or Data.Ml < Config.PerPuff then
		Notify(source,"O tanque está vazio. Use um líquido para recarregar.")
		return
	end

	LastPuff[source] = os.time()
	Data.Ml = math.max(0.0,Data.Ml - Config.PerPuff)
	SaveTank(Passport)
	vRP.DowngradeStress(Passport,Config.Stress)
	local Effect = Config.Flavors[Data.Flavor].Effect
	if Effect and Effect ~= "stress" then
		TriggerClientEvent("Night_Vape:Effect",source,Effect,Config.EffectDuration)
	end
	SyncTank(source,Passport)

	-- Vapor para quem está perto (inclusive o próprio jogador)
	local Coords = GetEntityCoords(GetPlayerPed(source))
	local Color = Config.Flavors[Data.Flavor].Color
	for _,Target in ipairs(GetPlayers()) do
		Target = tonumber(Target)
		if #(GetEntityCoords(GetPlayerPed(Target)) - Coords) <= Config.SyncDistance then
			TriggerClientEvent("Night_Vape:Smoke",Target,source,Color)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Vape:Store",function()
	Equipped[source] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	local Passport = Equipped[source]
	Equipped[source] = nil
	LastPuff[source] = nil

	if Passport then
		Tanks[Passport] = nil
	end
end)
