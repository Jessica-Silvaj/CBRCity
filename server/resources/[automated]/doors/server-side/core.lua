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
Tunnel.bindInterface("doors",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Doors = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("doors/CreateTable","CREATE TABLE IF NOT EXISTS `doors` (`id` INT(11) NOT NULL AUTO_INCREMENT, `name` VARCHAR(255) DEFAULT 'Porta', `hash` BIGINT(20) NOT NULL, `coords` VARCHAR(255) NOT NULL, `distance` FLOAT NOT NULL, `permission` VARCHAR(255) DEFAULT NULL, `other` INT(11) DEFAULT NULL, `lockState` TINYINT(1) DEFAULT 1, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;")
vRP.Prepare("doors/GetAll","SELECT * FROM doors")
vRP.Prepare("doors/Insert","INSERT INTO doors (name, hash, coords, distance, permission, other, lockState) VALUES (@name, @hash, @coords, @distance, @permission, @other, @lockState)")
vRP.Prepare("doors/UpdateOther","UPDATE doors SET other = @other WHERE id = @id")
vRP.Prepare("doors/UpdateLock","UPDATE doors SET lockState = @lockState WHERE id = @id")
vRP.Prepare("doors/UpdateConfig","UPDATE doors SET name = @name, distance = @distance, permission = @permission WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Management:requestDoors")
AddEventHandler("Night_Management:requestDoors", function()
    local source = source
    if source ~= "" and source ~= nil then return end
	vRP.Query("doors/CreateTable")

    pcall(function()
        exports.oxmysql:executeSync("ALTER TABLE doors ADD COLUMN name VARCHAR(255) DEFAULT 'Porta'")
    end)
    
	local consult = vRP.Query("doors/GetAll")
	if consult then
		for _,v in pairs(consult) do
			local coordsTable = json.decode(v.coords)
			if coordsTable then
				local coords = vec3(coordsTable.x, coordsTable.y, coordsTable.z)
                local center = vec3(coordsTable.cx or coordsTable.x, coordsTable.cy or coordsTable.y, coordsTable.cz or coordsTable.z)
				Doors[tostring(v.id)] = {
					Coords = coords,
                    Center = center,
					Hash = tonumber(v.hash),
                    Name = v.name or "Porta",
					Disabled = false,
					Lock = v.lockState == 1,
					Distance = tonumber(v.distance),
					Permission = v.permission,
					Other = v.other and tostring(v.other) or nil
				}
			end
		end
	end

	Wait(2000)
	TriggerClientEvent("doors:Connect", -1, Doors)
end)

function splitString(inputstr, sep)
	if sep == nil then sep = "%s" end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Number)
    local source = source
    local Passport = vRP.Passport(source)

    if not Passport then
        return false
    end

    Number = tostring(Number)
    local door = Doors[Number]

    if door and door.Permission and door.Permission ~= "" then
        local hasPerm = false
        for permInfo in string.gmatch(door.Permission, "([^;]+)") do
            local split = splitString(permInfo, ",")
            local group = split[1] and split[1]:gsub("^%s*(.-)%s*$", "%1") or ""
            local level = split[2] and tonumber(split[2]) or nil

            if group ~= "" then
                if level then
                    if vRP.HasGroup(Passport, group, level) or vRP.HasPermission(Passport, group, level) then
                        hasPerm = true
                        break
                    end
                else
                    if vRP.HasGroup(Passport, group) or vRP.HasPermission(Passport, group) then
                        hasPerm = true
                        break
                    end
                end
            end
        end

        if not hasPerm then
            return false
        end
    end

    if not Doors[Number] then return false end

    Doors[Number].Lock = not Doors[Number].Lock
    vRP.Query("doors/UpdateLock", { lockState = Doors[Number].Lock and 1 or 0, id = tonumber(Number) })

    local Other = Doors[Number].Other
    if Other and Doors[Other] then
        Doors[Other].Lock = Doors[Number].Lock
        vRP.Query("doors/UpdateLock", { lockState = Doors[Other].Lock and 1 or 0, id = tonumber(Other) })
    end

    TriggerClientEvent("doors:Sync",-1,Number,Doors[Number].Lock,Other)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE DOORS EXTERNALLY (from Night_Management)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("doors:addDynamicDoor")
AddEventHandler("doors:addDynamicDoor", function(idStr, data, otherIdStr, data2)
	Doors[idStr] = data
	if otherIdStr and data2 then
		Doors[otherIdStr] = data2
	end
	TriggerClientEvent("doors:Connect", -1, Doors)
end)

RegisterNetEvent("doors:editDynamicDoor")
AddEventHandler("doors:editDynamicDoor", function(idStr, name, distance, permission)
	if Doors[idStr] then
        if name then Doors[idStr].Name = name end
		Doors[idStr].Distance = distance
		Doors[idStr].Permission = permission
		TriggerClientEvent("doors:Connect", -1, Doors)
	end
end)

RegisterNetEvent("doors:removeDynamicDoor")
AddEventHandler("doors:removeDynamicDoor", function(idStr)
	if Doors[idStr] then
		local otherId = Doors[idStr].Other
		if otherId and Doors[otherId] then
			Doors[otherId].Other = nil
			Doors[otherId].Lock = false
			vRP.Query("doors/UpdateLock", { lockState = 0, id = tonumber(otherId) })
			vRP.Query("doors/UpdateOther", { other = 0, id = tonumber(otherId) })
		end
		
		for k, v in pairs(Doors) do
			if v.Other == idStr then
				v.Other = nil
				v.Lock = false
				vRP.Query("doors/UpdateLock", { lockState = 0, id = tonumber(k) })
				vRP.Query("doors/UpdateOther", { other = 0, id = tonumber(k) })
			end
		end

		Doors[idStr] = nil
		TriggerClientEvent("doors:Connect", -1, Doors)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("doors:Connect",source,Doors)
end)