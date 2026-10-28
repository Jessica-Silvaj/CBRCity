if Link.framework ~= 'vrp' then
    return
end

-- Adaptado para a base vRP Creative (Passport / GenerateItem / PaymentFull)
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

function GetPlayerJob(player)
    local Passport = vRP.Passport(player)
    if not Passport then return nil end

    local job = vRP.GetUserType(Passport, "Work")

    return job or nil, 1
end

function GetPlayersWithJob(jobs)
    local matchingPlayers = {}
    local isTable = type(jobs) == 'table'

    for _, src in ipairs(GetPlayers()) do
        local Passport = vRP.Passport(tonumber(src))
        if Passport then
            if isTable then
                for _, name in ipairs(jobs) do
                    if vRP.HasService(Passport, name) then
                        table.insert(matchingPlayers, tonumber(src))
                        break
                    end
                end
            elseif vRP.HasService(Passport, jobs) then
                table.insert(matchingPlayers, tonumber(src))
            end
        end
    end

    return matchingPlayers
end

function CanPlayerAfford(player, amount)
    local Passport = vRP.Passport(player)
    if not Passport then return false end

    return (vRP.ItemAmount(Passport, "dollar") + vRP.GetBank(Passport)) >= amount
end

function AddPlayerMoney(player, amount, account)
    local Passport = vRP.Passport(player)
    if not Passport then return false end

    if account == "bank" then
        vRP.GiveBank(Passport, amount, true)
    else
        vRP.GenerateItem(Passport, "dollar", amount, true)
    end

    return true
end

function RemovePlayerMoney(player, amount)
    local Passport = vRP.Passport(player)
    if not Passport then return false end

    return vRP.PaymentFull(Passport, amount, true) and true or false
end

function GetPlayerItemData(player, item)
    local Passport = vRP.Passport(player)
    if not Passport then
        return { count = 0 }
    end

    return {
        count = vRP.ItemAmount(Passport, item) or 0
    }
end

function GetPlayerItemCount(player, item)
    local data = GetPlayerItemData(player, item)
    return data.count
end

function AddPlayerItem(player, item, amount, meta)
    local Passport = vRP.Passport(player)
    if not Passport then return false end

    vRP.GenerateItem(Passport, item, amount or 1, true)
    return true
end

function RemovePlayerItem(player, item, amount)
    local Passport = vRP.Passport(player)
    if not Passport then return false end

    return vRP.TakeItem(Passport, item, amount or 1, true) and true or false
end

function RegisterUsableItem(item, cb)
    return true -- no vRP o uso do item é definido na configuração do próprio item
end

function OpenCustomStash()
    -- Não disponível no vRP
    return true
end

function GetStashItems()
    -- Não disponível no vRP
    return {}
end

function GetPlayerCharacterId(player)
    return vRP.Passport(player)
end

function GetPlayerCharacterName(player)
    local Passport = vRP.Passport(player)
    if not Passport then
        return GetPlayerName(player) or 'Unknown'
    end

    return vRP.FullName(Passport) or GetPlayerName(player) or 'Unknown'
end

function AddPlayerWeapon(player, weapon, ammo)
    local Passport = vRP.Passport(player)
    if not Passport then return false end

    vRP.GenerateItem(Passport, weapon, 1, true)
    if ammo and ammo > 0 then
        local ammoType = weapon:gsub('WEAPON_', 'AMMO_')
        vRP.GenerateItem(Passport, ammoType, ammo, true)
    end

    return true
end

function DoesPlayerHaveWeapon(player, weapon)
    return GetPlayerItemCount(player, weapon) > 0
end

function RemovePlayerWeapon(player, weapon)
    return RemovePlayerItem(player, weapon, 1)
end
