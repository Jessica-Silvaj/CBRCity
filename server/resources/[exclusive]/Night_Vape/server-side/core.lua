-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = module("vrp","lib/Proxy").getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tanks = {}
local Equipped = {}
local EquippedItem = {}
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
	TriggerClientEvent("Night_Vape:Tank",source,Data.Ml,Config.Capacity,Flavor and Flavor.Name or nil,Flavor and Flavor.Color or nil)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE: chamado pelo inventory ao usar o item vape
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasVape(Passport)
	for Item in pairs(Config.Vapes) do
		if vRP.ConsultItem(Passport,Item,1) then
			return true
		end
	end

	return false
end

local OpenRefill

-- Usar o vape (inventário ou hotbar) = uma puxada completa; com o tanque vazio abre o painel de recarga
local function Toggle(source,Passport,Item)
	Item = Config.Vapes[Item] and Item or "vape"

	local State = Player(source).state
	if State.Death or State.Crawl or State.Handcuff then
		return
	end

	TriggerClientEvent("inventory:Close",source)

	if Tank(Passport).Ml < Config.PerPuff * 0.5 then
		OpenRefill(source,Passport,Item)
		return
	end

	Equipped[source] = Passport
	EquippedItem[source] = Item
	SyncTank(source,Passport)
	TriggerClientEvent("Night_Vape:Use",source,Item)
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

	if not HasVape(Passport) then
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
-- PAINEL DE RECARGA: lista os líquidos da mochila e recarrega pelo escolhido
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenRefill(source,Passport,Vape)
	local Liquids = {}
	for Item,Flavor in pairs(Config.Flavors) do
		local Consult = vRP.ConsultItem(Passport,Item,1)
		local Effect = Config.Effects[Flavor.Effect] or {}
		Liquids[#Liquids + 1] = { Item = Item, Name = Flavor.Name, Color = Flavor.Color, Effect = Effect.Label, Description = Effect.Description, Amount = Consult and Consult.Amount or 0 }
	end

	table.sort(Liquids,function(a,b)
		if (a.Amount > 0) ~= (b.Amount > 0) then
			return a.Amount > 0
		end

		return a.Name < b.Name
	end)

	local Data = Tank(Passport)
	local Flavor = Data.Flavor and Config.Flavors[Data.Flavor]
	TriggerClientEvent("Night_Vape:RefillPanel",source,{
		Liquids = Liquids,
		Ml = Data.Ml,
		Capacity = Config.Capacity,
		Bottle = Config.BottleSize,
		Flavor = Data.Flavor,
		FlavorName = Flavor and Flavor.Name or nil,
		Color = Flavor and Flavor.Color or nil,
		Vape = Config.Vapes[Vape] and Config.Vapes[Vape].Name or "Vape"
	})
end

RegisterNetEvent("Night_Vape:RefillFrom",function(Item)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not Config.Flavors[Item] then
		return
	end

	local Consult = vRP.ConsultItem(Passport,Item,1)
	if not Consult then
		Notify(source,"Você não tem esse líquido.")
		return
	end

	Refill(source,Passport,Item,Consult.Item,Consult.Slot)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIQUIDS: o inventory registra estes itens como usáveis
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Vapes",function()
	local List = {}
	for Item in pairs(Config.Vapes) do
		List[#List + 1] = Item
	end

	return List
end)

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
RegisterNetEvent("Night_Vape:Puff",function(Intensity)
	local source = source
	-- 0.0 = puxada curta, 1.0 = longa (Config.Intensity)
	Intensity = math.min(1.0,math.max(0.0,tonumber(Intensity) or 1.0))
	local Passport = Equipped[source]
	if not Passport or vRP.Passport(source) ~= Passport then
		return
	end

	if LastPuff[source] and os.time() - LastPuff[source] < Config.PuffCooldown then
		return
	end

	if not vRP.ConsultItem(Passport,EquippedItem[source],1) then
		Equipped[source] = nil
		EquippedItem[source] = nil
		return
	end

	local Data = Tank(Passport)
	if not Data.Flavor or Data.Ml < Config.PerPuff * 0.5 then
		Notify(source,"O tanque está vazio. Use um líquido para recarregar.")
		return
	end

	LastPuff[source] = os.time()
	local Before = Data.Ml
	Data.Ml = math.max(0.0,Data.Ml - Config.PerPuff * (0.5 + Intensity))

	local Low = Config.Capacity * Config.LowTank
	if Data.Ml < Config.PerPuff * 0.5 then
		Notify(source,"O líquido acabou. Use um líquido para recarregar.")
	elseif Before > Low and Data.Ml <= Low then
		Notify(source,"Tanque quase vazio ("..string.format("%.1f",Data.Ml).." ml).")
	end
	SaveTank(Passport)
	local Effect = Config.Flavors[Data.Flavor].Effect
	vRP.DowngradeStress(Passport,Effect == "stress" and Config.Stress * 3 or Config.Stress)
	if Config.Effects[Effect] then
		TriggerClientEvent("Night_Vape:Effect",source,Effect)
	end
	SyncTank(source,Passport)

	-- Vapor para quem está perto (inclusive o próprio jogador)
	local Coords = GetEntityCoords(GetPlayerPed(source))
	local Color = Config.Flavors[Data.Flavor].Color
	for _,Target in ipairs(GetPlayers()) do
		Target = tonumber(Target)
		if #(GetEntityCoords(GetPlayerPed(Target)) - Coords) <= Config.SyncDistance then
			TriggerClientEvent("Night_Vape:Smoke",Target,source,Color,Intensity)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Vape:Store",function()
	Equipped[source] = nil
	EquippedItem[source] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function()
	local Passport = Equipped[source]
	Equipped[source] = nil
	EquippedItem[source] = nil
	LastPuff[source] = nil

	if Passport then
		Tanks[Passport] = nil
	end
end)
