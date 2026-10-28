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
Tunnel.bindInterface("shortcuts",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Shortcuts = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHORTCUTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Shortcuts()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and not Player(source)["state"]["Handcuff"] then
        local Inventory = vRP.Inventory(Passport)
        if Inventory then
            local ShortcutsData = {}
            for i = 1,5 do
                local internalSlot = tostring(i - 1)
                local Slot = tostring(i)
                local ItemData = Inventory[internalSlot] or Inventory[i - 1]

                if ItemData and ItemData["item"] then
                    ShortcutsData[Slot] = exports["vrp"]:ItemIndex(ItemData["item"])
                else
                    if i == 5 then
                        ShortcutsData[Slot] = "mochila"
                    else
                        ShortcutsData[Slot] = ""
                    end
                end
            end

            return ShortcutsData
        end
    end

    return false
end