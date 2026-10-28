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
Tunnel.bindInterface("crafting",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport or not List[Name] then
        return false
    end

    if exports.bank:CheckTaxes(Passport) or exports.bank:CheckFines(Passport) then
        return false
    end

    local Permission = List[Name].Permission
    return not Permission or vRP.HasService(Passport,Permission)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount(Name)
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
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if not (List[Name] and List[Name].List and List[Name].List[Item]) then
		return false
	end

	local Amount = parseInt(Amount,true)
	if exports.vrp:ItemUnique(Item) and Amount > 1 then
		Amount = 1
	end

	local DoesExist = exports.vrp:ItemExist(Item)
	if DoesExist and DoesExist.Blueprint and not exports.inventory:Blueprint(Passport,Item) then
		TriggerClientEvent("inventory:Notify",source,"Aviso","Aprendizado não encontrado.","amarelo")
		return false
	end

	local Target = tostring(Target)
	local Recipe = List[Name].List[Item]
	local Inventory = vRP.Inventory(Passport)
	local TotalAmount = Recipe.Amount * Amount

	if vRP.MaxItens(Passport,Item,TotalAmount) or not vRP.CheckWeight(Passport,Item,TotalAmount) or (Inventory[Target] and Inventory[Target].item ~= Item) then
		return false
	end

	local RemoveList = {}
	for Required,Multiplier in pairs(Recipe.Required) do
		local NeedAmount = Multiplier * Amount
		local ConsultItem = vRP.ConsultItem(Passport,Required,NeedAmount)

		if not ConsultItem then
			TriggerClientEvent("inventory:Notify",source,"Atenção","Precisa de <default>"..Dotted(NeedAmount).."x "..exports.vrp:ItemName(Required).."</default>.","vermelho")
			return false
		end

		RemoveList[ConsultItem.Item] = NeedAmount
	end

	for Item,Multiplier in pairs(RemoveList) do
		vRP.RemoveItem(Passport,Item,Multiplier)
	end

	vRP.GenerateItem(Passport,Item,TotalAmount,false,Target)

	TriggerClientEvent("inventory:Update",source)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- NIGHTADMIN INTEGRATION
-----------------------------------------------------------------------------------------------------------------------------------------
local CachedCraftings = {}

AddEventHandler("Connect", function(Passport, source)
	TriggerClientEvent("crafting:updateCraftings", source, CachedCraftings)
	TriggerClientEvent("crafting:updateConfigs", source, List)
end)

RegisterNetEvent("Night_Management:requestCrafting")
AddEventHandler("Night_Management:requestCrafting", function()
    local source = source
    if source ~= "" and source ~= nil then return end
	local craftings = exports.oxmysql:executeSync("SELECT * FROM crafting")
	CachedCraftings = craftings or {}
	local configs = exports.oxmysql:executeSync("SELECT * FROM crafting_configs")
	
	local formatedList = {}
	if configs then
		for _, v in pairs(configs) do
			formatedList[v.Mode] = {
				Permission = (v.Permission and v.Permission ~= "") and v.Permission or nil,
				List = json.decode(v.List)
			}
		end
	end

	List = formatedList
	ItemList = {}
	for Index,v in pairs(List) do
		local Result = {}
		for Key,Recipe in pairs(v.List) do
			Result[#Result + 1] = {
				key = Key,
				price = Recipe.Amount,
				required = Recipe.Required
			}
		end
		ItemList[Index] = Result
	end

	TriggerClientEvent("crafting:updateCraftings", -1, craftings)
	TriggerClientEvent("crafting:updateConfigs", -1, formatedList)
end)

