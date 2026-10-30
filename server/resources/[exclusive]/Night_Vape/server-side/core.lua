-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = module("vrp","lib/Proxy").getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tanks = {}
local Bottles = {}
local Equipped = {}
local EquippedItem = {}
local LastPuff = {}
local Pouring = {}
local Warned = {}
local Serene = {}
local SereneLoop = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
local function Notify(source,Message,Color)
	TriggerClientEvent("Notify",source,"Vape",Message,Color or "amarelo",5000)
end

local function Round(Value)
	return math.floor(Value * 100 + 0.5) / 100
end

local function Device(Vape)
	return Config.Vapes[Vape] or Config.Vapes["vape"]
end

local function Capacity(Vape)
	return Device(Vape).Capacity or Config.Capacity
end

-- menor puxada possível desse vape (abaixo disso o tanque conta como vazio)
local function MinPuff(Vape)
	return Config.PerPuff * 0.5 * (Device(Vape).Consumption or 1.0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TANK: cada vape tem o próprio tanque; o "vape" mantém a chave antiga (NightVape) para não perder a carga salva
-----------------------------------------------------------------------------------------------------------------------------------------
local function TankKey(Vape)
	return Vape == "vape" and "NightVape" or "NightVape:"..Vape
end

local function Tank(Passport,Vape)
	Vape = Config.Vapes[Vape] and Vape or "vape"
	Tanks[Passport] = Tanks[Passport] or {}

	if not Tanks[Passport][Vape] then
		local Data = vRP.UserData(Passport,TankKey(Vape))
		Tanks[Passport][Vape] = {
			Ml = type(Data) == "table" and math.min(Capacity(Vape),tonumber(Data.Ml) or 0.0) or 0.0,
			Flavor = type(Data) == "table" and Config.Flavors[Data.Flavor] and Data.Flavor or nil
		}
	end

	return Tanks[Passport][Vape]
end

local function SaveTank(Passport,Vape)
	Vape = Config.Vapes[Vape] and Vape or "vape"
	local Data = Tanks[Passport] and Tanks[Passport][Vape]
	if Data then
		vRP.Query("playerdata/SetData",{ Passport = Passport, Name = TankKey(Vape), Information = json.encode({ Ml = Data.Ml, Flavor = Data.Flavor }) })
	end
end

local function SyncTank(source,Passport,Vape)
	local Data = Tank(Passport,Vape)
	local Flavor = Data.Flavor and Config.Flavors[Data.Flavor]
	TriggerClientEvent("Night_Vape:Tank",source,Data.Ml,Capacity(Vape),Flavor and Flavor.Name or nil,Flavor and Flavor.Color or nil)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOTTLES: o frasco aberto de cada sabor guarda o que sobrou (um frasco pela metade continua pela metade)
-----------------------------------------------------------------------------------------------------------------------------------------
local function OpenBottles(Passport)
	if not Bottles[Passport] then
		local Data = vRP.UserData(Passport,"NightVapeBottles")
		Bottles[Passport] = {}

		if type(Data) == "table" then
			for Item,Ml in pairs(Data) do
				if Config.Flavors[Item] and tonumber(Ml) and tonumber(Ml) > 0 then
					Bottles[Passport][Item] = math.min(Config.BottleSize,tonumber(Ml))
				end
			end
		end
	end

	return Bottles[Passport]
end

local function SaveBottles(Passport)
	if Bottles[Passport] then
		vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "NightVapeBottles", Information = json.encode(Bottles[Passport]) })
	end
end

-- líquido disponível de um sabor: frasco aberto + frascos fechados na mochila
local function Available(Passport,Item)
	local Consult = vRP.ConsultItem(Passport,Item,1)
	local Closed = Consult and Consult.Amount or 0
	local Open = OpenBottles(Passport)[Item] or 0

	return Open,Closed
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTAÇÃO DE RECARGA: todos os vapes da mochila, o líquido de cada um e os frascos
-----------------------------------------------------------------------------------------------------------------------------------------
local function OpenRefill(source,Passport,Selected,Liquid,Update)
	local Vapes = {}
	for Item,Prop in pairs(Config.Vapes) do
		if vRP.ConsultItem(Passport,Item,1) then
			local Data = Tank(Passport,Item)
			local Flavor = Data.Flavor and Config.Flavors[Data.Flavor]
			Vapes[#Vapes + 1] = {
				Item = Item,
				Name = Prop.Name,
				Style = Prop.Style or "classic",
				Ml = Round(Data.Ml),
				Capacity = Capacity(Item),
				Consumption = Prop.Consumption or 1.0,
				Flavor = Data.Ml > 0 and Data.Flavor or nil,
				FlavorName = Data.Ml > 0 and Flavor and Flavor.Name or nil,
				Color = Data.Ml > 0 and Flavor and Flavor.Color or nil
			}
		end
	end

	if #Vapes == 0 then
		Notify(source,"Você precisa de um vape para usar o líquido.")
		return
	end

	table.sort(Vapes,function(a,b) return a.Name < b.Name end)

	local Liquids = {}
	for Item,Flavor in pairs(Config.Flavors) do
		local Open,Closed = Available(Passport,Item)
		local Effect = Config.Effects[Flavor.Effect] or {}
		Liquids[#Liquids + 1] = { Item = Item, Name = Flavor.Name, Color = Flavor.Color, Effect = Effect.Label, Description = Effect.Description, Amount = Closed, Open = Round(Open) }
	end

	table.sort(Liquids,function(a,b)
		local HasA,HasB = a.Amount > 0 or a.Open > 0,b.Amount > 0 or b.Open > 0
		if HasA ~= HasB then
			return HasA
		end

		return a.Name < b.Name
	end)

	TriggerClientEvent("Night_Vape:RefillPanel",source,{
		Update = Update or false,
		Vapes = Vapes,
		Liquids = Liquids,
		Selected = Config.Vapes[Selected] and Selected or nil,
		Liquid = Config.Flavors[Liquid] and Liquid or nil,
		Bottle = Config.BottleSize,
		AllowMix = Config.AllowMix
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE: chamado pelo inventory ao usar o item vape
-----------------------------------------------------------------------------------------------------------------------------------------
-- Usar o vape (inventário ou hotbar) = uma puxada; com o tanque vazio abre a estação de recarga
local function Toggle(source,Passport,Item)
	Item = Config.Vapes[Item] and Item or "vape"

	local State = Player(source).state
	if State.Death or State.Crawl or State.Handcuff then
		return
	end

	TriggerClientEvent("inventory:Close",source)

	if Tank(Passport,Item).Ml < MinPuff(Item) then
		OpenRefill(source,Passport,Item)
		return
	end

	Equipped[source] = Passport
	EquippedItem[source] = Item
	SyncTank(source,Passport,Item)
	TriggerClientEvent("Night_Vape:Use",source,Item)
end
exports("Toggle",Toggle)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REFILL: usar um líquido pelo inventário abre a estação com aquele frasco já escolhido
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Refill",function(source,Passport,Item)
	if not Config.Flavors[Item] then
		return false
	end

	TriggerClientEvent("inventory:Close",source)
	OpenRefill(source,Passport,EquippedItem[source],Item)

	return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POUR: despeja o frasco escolhido no vape escolhido (o líquido que sobra fica no frasco aberto)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Vape:Pour",function(Vape,Item)
	local source = source
	local Passport = vRP.Passport(source)
	local Flavor = Config.Flavors[Item]
	if not Passport or not Flavor or not Config.Vapes[Vape] or Pouring[source] then
		return
	end

	if not vRP.ConsultItem(Passport,Vape,1) then
		Notify(source,"Esse vape não está mais na mochila.")
		return OpenRefill(source,Passport,nil,Item,true)
	end

	local Data = Tank(Passport,Vape)
	local Cap = Capacity(Vape)

	-- sem mistura: um sabor diferente só entra com o tanque vazio
	if Data.Ml >= MinPuff(Vape) and Data.Flavor and Data.Flavor ~= Item and not Config.AllowMix then
		Notify(source,"Esse tanque tem outro sabor. Esvazie antes de colocar "..Flavor.Name..".")
		return
	end

	local Space = Cap - Data.Ml
	if Space < 0.01 then
		Notify(source,"O tanque já está cheio.")
		return
	end

	local Open = OpenBottles(Passport)
	if not Open[Item] or Open[Item] <= 0 then
		local Consult = vRP.ConsultItem(Passport,Item,1)
		if not Consult or not vRP.TakeItem(Passport,Consult.Item,1,true,Consult.Slot) then
			Notify(source,"Você não tem esse líquido.")
			return
		end

		Open[Item] = Config.BottleSize
	end

	Pouring[source] = true

	local Pour = math.min(Space,Open[Item])
	Open[Item] = Round(Open[Item] - Pour)
	if Open[Item] <= 0 then
		Open[Item] = nil
	end
	SaveBottles(Passport)

	-- com mistura o líquido novo define o sabor (e a cor) do tanque inteiro; a quantidade é somada
	Data.Ml = Round(math.min(Cap,Data.Ml + Pour))
	Data.Flavor = Item
	SaveTank(Passport,Vape)
	Warned[Passport .. Vape] = nil

	TriggerClientEvent("Night_Vape:Refill",source,Vape)
	SyncTank(source,Passport,Vape)
	Notify(source,Device(Vape).Name.." recarregado com "..Flavor.Name.." ("..string.format("%.1f",Data.Ml).." ml).","verde")

	SetTimeout(Config.Refill.Duration,function()
		Pouring[source] = nil
		if vRP.Passport(source) == Passport then
			OpenRefill(source,Passport,Vape,Item,true)
		end
	end)
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

	local Vape = EquippedItem[source]
	local Prop = Device(Vape)
	local Data = Tank(Passport,Vape)
	if not Data.Flavor or Data.Ml < MinPuff(Vape) then
		Notify(source,"O tanque está vazio. Use um líquido para recarregar.")
		return
	end

	LastPuff[source] = os.time()

	-- cada modelo gasta diferente (Consumption) e solta uma nuvem diferente (Cloud)
	local Cost = math.min(Data.Ml,Config.PerPuff * (0.5 + Intensity) * (Prop.Consumption or 1.0))
	Data.Ml = Round(math.max(0.0,Data.Ml - Cost))

	local Low = Capacity(Vape) * Config.LowTank
	if Data.Ml < MinPuff(Vape) then
		Notify(source,"O líquido acabou. Use um líquido para recarregar.")
	elseif Data.Ml <= Low and not Warned[Passport .. Vape] then
		-- uma vez por recarga: notificação + 3 bipes
		Warned[Passport .. Vape] = true
		Notify(source,"Tanque quase vazio ("..string.format("%.1f",Data.Ml).." ml).")
		TriggerClientEvent("Night_Vape:Beep",source)
	end
	SaveTank(Passport,Vape)

	local Effect = Config.Flavors[Data.Flavor].Effect
	vRP.DowngradeStress(Passport,Effect == "stress" and Config.Stress * 3 or Config.Stress)
	-- sabor "Refrescante" mata um pouco da sede a cada puxada
	if Effect == "fresh" then
		vRP.UpgradeThirst(Passport,3)
	-- sabor "Tropical" mata um pouco da fome a cada puxada
	elseif Effect == "tropical" then
		vRP.UpgradeHunger(Passport,3)
	-- sabor "Sereno" tira 1 de estresse a cada 5 segundos enquanto dura (puxar de novo reinicia)
	elseif Effect == "serene" then
		Serene[Passport] = os.time() + Config.Effects.serene.Duration
		if not SereneLoop[Passport] then
			SereneLoop[Passport] = true
			CreateThread(function()
				while Serene[Passport] and os.time() < Serene[Passport] and vRP.Source(Passport) do
					Wait(5000)
					vRP.DowngradeStress(Passport,1)
				end

				Serene[Passport] = nil
				SereneLoop[Passport] = nil
			end)
		end
	end
	if Config.Effects[Effect] then
		TriggerClientEvent("Night_Vape:Effect",source,Effect)
	end
	SyncTank(source,Passport,Vape)

	-- Vapor para quem está perto (inclusive o próprio jogador); o tamanho segue o líquido gasto
	local Coords = GetEntityCoords(GetPlayerPed(source))
	local Color = Config.Flavors[Data.Flavor].Color
	local Cloud = Intensity * (Prop.Cloud or 1.0)
	for _,Target in ipairs(GetPlayers()) do
		Target = tonumber(Target)
		if #(GetEntityCoords(GetPlayerPed(Target)) - Coords) <= Config.SyncDistance then
			TriggerClientEvent("Night_Vape:Smoke",Target,source,Color,Cloud)
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
	local Passport = Equipped[source] or vRP.Passport(source)
	Equipped[source] = nil
	EquippedItem[source] = nil
	LastPuff[source] = nil
	Pouring[source] = nil

	if Passport then
		Tanks[Passport] = nil
		Bottles[Passport] = nil
	end
end)
