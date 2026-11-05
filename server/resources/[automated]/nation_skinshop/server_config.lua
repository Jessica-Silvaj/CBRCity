---------------------------------------------------------------------------
-- VRP
---------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_skinshop")
func = {}
Tunnel.bindInterface("nation_skinshop", func)
---------------------------------------------------------------------------
-- VERIFICAÇÃO DE PERMISSÃO
---------------------------------------------------------------------------
function func.checkPermission(permission)
    local source = source
    local user_id = vRP.Passport(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasGroup(user_id, perm) then
                return true
            end
        end
        return false
    end
    return vRP.HasGroup(user_id, permission)
end

function func.tryPayClothes(value)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and value >= 0 then
        if value == 0 or vRP.PaymentFull(Passport, value) or vRP.PaymentBank(Passport, value) then
            local clothes = fclient.getCloths(source)
            if clothes then
                vRP.Query("playerdata/SetData", { Passport = Passport, Name = "Clothings", Information = json.encode(clothes) })
            end
            TriggerClientEvent("updateRoupas", source, clothes)
            return true
        end
    end
    return false
end

function func.updateClothes(custom)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local clothes = custom or fclient.getCloths(source)
        if clothes then
            vRP.Query("playerdata/SetData", { Passport = Passport, Name = "Clothings", Information = json.encode(clothes) })
        end
    end
end

RegisterNetEvent("nation_skinshop:updateClothes")
AddEventHandler("nation_skinshop:updateClothes", function(clothes)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local userClothes = clothes or fclient.getCloths(source)
        if userClothes then
            vRP.Query("playerdata/SetData", { Passport = Passport, Name = "Clothings", Information = json.encode(userClothes) })
        end
    end
end)

RegisterNetEvent("skinshop:save")
AddEventHandler("skinshop:save", function(clothes)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local userClothes = clothes or fclient.getCloths(source)
        if userClothes then
            vRP.Query("playerdata/SetData", { Passport = Passport, Name = "Clothings", Information = json.encode(userClothes) })
        end
    end
end)

exports("Add", function(Table)
    -- Compatibilidade com itens de adicionar loja
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPATIBILIDADE SKINSHOP (SERVER-SIDE)
-----------------------------------------------------------------------------------------------------------------------------------------
local skinshopCompat = {}
Tunnel.bindInterface("skinshop", skinshopCompat)
vRPC = Tunnel.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source, Message)
    local Passport = vRP.Passport(source)
    if Passport and Message[1] then
        if vRP.HasGroup(Passport, "Admin") then
            local ClosestPed = vRP.Source(Message[1])
            if ClosestPed then
                vRPC.Skin(ClosestPed, Message[2])
                vRP.SkinCharacter(parseInt(Message[1]), Message[2])
                vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Skin", dvalue = Message[2] })

                local sex = nil
                if Message[2] == "mp_m_freemode_01" then
                    sex = "M"
                elseif Message[2] == "mp_f_freemode_01" then
                    sex = "F"
                end

                if sex then
                    vRP.Query("characters/SetSex", { Passport = Passport, sex = sex })
                end
            end
        end
    end
end)

RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if vRP.HasService(Passport,"Policia") or vRP.HasService(Passport,"Emergencia") then
				TriggerClientEvent("skinshop:set"..Mode,ClosestPed)
			end
		end
	end
end)

RegisterServerEvent("skinshop:Send")
AddEventHandler("skinshop:Send",function()
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	local OtherSource = vRPC.ClosestPed(source,2)
	if not OtherSource or vRP.GetHealth(OtherSource) <= 100 then
		return false
	end

	if vRP.ModelPlayer(source) ~= vRP.ModelPlayer(OtherSource) then
		TriggerClientEvent("Notify",source,"Aviso","Vestimentas recusadas.","amarelo",5000)
		return false
	end

	if vRP.Request(OtherSource,false,"Aceitar vestimentas de <b>"..vRP.FullName(Passport).."</b>?") then
		TriggerClientEvent("Notify",source,"Sucesso","Vestimentas enviadas.","verde",5000)
		local clothes = vRP.UserData(Passport,"Clothings")
		TriggerClientEvent("skinshop:Apply",OtherSource,clothes,true)
	else
		TriggerClientEvent("Notify",source,"Aviso","Vestimentas recusadas.","amarelo",5000)
	end
end)

function skinshopCompat.Customization(source)
    local Passport = vRP.Passport(source)
    if Passport then
        local data = vRP.UserData(Passport, "Clothings")
        if data and type(data) == "table" and next(data) then
            return data
        end
        local query = vRP.Query("playerdata/GetData", { Passport = Passport, dkey = "Clothings" })
        if type(query) == "table" and query[1] and query[1].Information then
            return json.decode(query[1].Information)
        end
    end
    return {}
end

exports("Customization", function(source)
    return skinshopCompat.Customization(source)
end)