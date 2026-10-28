-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("shops",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOLVE SHOP NAME HELPER
-----------------------------------------------------------------------------------------------------------------------------------------
local function ResolveShopName(Name)
	if not Name then return Name end
	if List[Name] then return Name end
	if List[tostring(Name)] then return tostring(Name) end
	if tonumber(Name) and List[tonumber(Name)] then return tonumber(Name) end
	return Name
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
	Name = ResolveShopName(Name)
	local source = source
	local Data = List[Name]
	local Passport = vRP.Passport(source)
	if not Passport or not Data then
		TriggerClientEvent("Notify",source,"Atenção","A loja não foi carregada corretamente no servidor ou você não está autenticado ("..tostring(Name)..").","amarelo",5000)
		return false
	end

	if Name ~= "Banned" and (exports.bank:CheckTaxes(Passport) or exports.bank:CheckFines(Passport)) then
		TriggerClientEvent("Notify",source,"Atenção","Você possui multas ou impostos pendentes.","amarelo",5000)
		return false
	end

	if not Data.Permission then
		return true
	end

	local HasPerm = vRP.HasService(Passport,Data.Permission)
	if not HasPerm then
		TriggerClientEvent("Notify",source,"Atenção","Você não tem permissão para acessar esta loja.","amarelo",5000)
	end
	return HasPerm and true or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount(Name)
	Name = ResolveShopName(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Name and List[Name] then
		local Primary = {}
		local Inv = vRP.Inventory(Passport)
		for Slot,v in pairs(Inv) do
			if v.amount <= 0 or not exports.vrp:ItemExist(v.item) then
				vRP.CleanSlot(Passport,Slot)
			else
				v.key = v.item

				local Split = splitString(v.item)
				local Item = Split[1]

				if not v.desc then
					if Item == "vehiclekey" and Split[3] then
						local Consult = exports.oxmysql:single_async("SELECT * FROM vehicles WHERE Plate = ? LIMIT 1",{ Split[3] })
						if Consult and exports.vrp:VehicleExist(Consult.Vehicle) then
							v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common><br>Modelo: <common>"..exports.vrp:VehicleName(Consult.Vehicle).."</common><br>Placa: <common>"..Split[3].."</common>"
						end
					elseif Item == "propertys" and Split[2] then
						local Consult = exports.oxmysql:single_async("SELECT * FROM propertys WHERE Serial = ? LIMIT 1",{ Split[2] })
						if Consult then
							v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common>"
						end
					elseif Item == "trabalho" then
						local Job = Player(source)["state"]["Job"]
						if Job then
							v.desc = "Assinada com o emprego: <common>"..(Works and Works[Job] or Job).."</common>"
						else
							v.desc = "Assinada com o emprego: <common>Nenhum</common>"
						end
					elseif exports.vrp:ItemNamed(Item) and Split[2] and vRP.Identity(Split[2]) then
						if Item == "identity" then
							v.desc = "Passaporte: <rare>"..Dotted(Split[2]).."</rare><br>Nome: <rare>"..vRP.FullName(Split[2]).."</rare><br>Telefone: <rare>"..vRP.Phone(Split[2]).."</rare>"
						else
							v.desc = "Proprietário: <common>"..vRP.FullName(Split[2]).."</common>"
						end
					end
				end

				if Split[2] then
					local Loaded = exports.vrp:ItemLoads(v.item)
					if Loaded then
						v.charges = parseInt(Split[2] * (100 / Loaded))
					end

					if exports.vrp:ItemDurability(v.item) then
						v.durability = parseInt(os.time() - Split[2])
						v.days = exports.vrp:ItemDurability(v.item)
					end
				end

				Primary[Slot] = v
			end
		end

		return Primary,vRP.GetWeight(Passport),vRP.InventorySlots(Passport)
	end
end
---------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Amount,Target,Name)
	Name = ResolveShopName(Name)
	local source = source
	local Target = tostring(Target)
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and Item and Target and List[Name] and List[Name]["Type"] and List[Name]["List"] and List[Name]["List"][Item] then
		if Amount > 1 and (exports.vrp:ItemUnique(Item) or exports.vrp:ItemLoads(Item)) then
			Amount = 1
		end

		if List[Name].Route and List[Name].Route ~= GetPlayerRoutingBucket(source) then
			TriggerClientEvent("inventory:Update",source)
			return false
		end

		local Inventory = vRP.Inventory(Passport)
		if not vRP.MaxItens(Passport,Item,Amount) and vRP.CheckWeight(Passport,Item,Amount) and (not Inventory[Target] or (Inventory[Target] and Inventory[Target]["item"] == Item)) then
			if List[Name]["Type"] == "Cash" then
				if vRP.PaymentFull(Passport,List[Name]["List"][Item] * Amount) then
					vRP.GenerateItem(Passport,Item,Amount,false,Target)
				else
					TriggerClientEvent("inventory:Notify",source,"Aviso","Dinheiro insuficiente.","amarelo")
				end
			elseif List[Name]["Type"] == "Consume" and List[Name]["Item"] then
				if vRP.TakeItem(Passport,List[Name]["Item"],List[Name]["List"][Item] * Amount) then
					vRP.GenerateItem(Passport,Item,Amount,false,Target)
				else
					TriggerClientEvent("inventory:Notify",source,"Atenção","<b>"..exports.vrp:ItemName(List[Name]["Item"]).."</b> insuficiente.","vermelho")
				end
			elseif List[Name]["Type"] == "Gemstone" then
				if vRP.PaymentGems(Passport,List[Name]["List"][Item] * Amount) then
					vRP.GenerateItem(Passport,Item,Amount,false,Target)
				else
					TriggerClientEvent("inventory:Notify",source,"Atenção","<b>Diamantes</b> insuficiente.","vermelho")
				end
			end
		end
	end

	TriggerClientEvent("inventory:Update",source)
end
---------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Amount,Slot,Name)
	local source = source
	local Split = SplitOne(Item)
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and List[Name] and List[Name]["List"] and List[Name]["Type"] and List[Name]["List"][Split] and not vRP.CheckDamaged(Item) then
		if List[Name]["Type"] == "Cash" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GenerateItem(Passport,"dollar",List[Name]["List"][Split] * Amount,false)
			end
		elseif List[Name]["Type"] == "Consume" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GenerateItem(Passport,List[Name]["Item"],List[Name]["List"][Split] * Amount,false)
			end
		end
	end

	TriggerClientEvent("inventory:Update",source)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- NIGHTADMIN INTEGRATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:updateConfigsFromAdmin")
AddEventHandler("shops:updateConfigsFromAdmin", function(configs)
	List = configs
	ItemList = {}

	for Shop, v in pairs(List) do
		ItemList[Shop] = {}
		if v.List then
			for Key, Amount in pairs(v.List) do
				table.insert(ItemList[Shop], { price = Amount, key = Key })
			end
		end
	end
end)

