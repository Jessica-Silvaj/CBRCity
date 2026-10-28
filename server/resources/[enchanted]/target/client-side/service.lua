-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Services = {}
local ActiveServiceZones = {}
local ServiceStates = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: PARSEPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function ParsePermissions(permString)
	local perms = {}
	if permString and permString ~= "" then
		for perm in string.gmatch(permString, "[^;,]+") do
			local cleanPerm = perm:gsub("^%s*(.-)%s*$", "%1")
			if cleanPerm ~= "" then
				table.insert(perms, cleanPerm)
			end
		end
	end
	return perms
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESERVICEZONES
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateServiceZones(serviceList)
	for _, zoneName in ipairs(ActiveServiceZones) do
		exports.target:RemCircleZone(zoneName)
	end
	ActiveServiceZones = {}

	Services = serviceList or {}

	for Index, v in pairs(Services) do
		local zoneName = "Service:" .. (v.id or Index)
		local coords = v.Coords
		if not coords and v.X and v.Y and v.Z then
			coords = vec3(tonumber(v.X) or 0.0, tonumber(v.Y) or 0.0, tonumber(v.Z) or 0.0)
		end

		if coords then
			local weight = tonumber(v.Weight) or 1.0
			local distance = tonumber(v.Distance) or 1.5
			local perms = ParsePermissions(v.Permission)
			local hasMultiple = #perms > 1

			local options = {}
			for _, permName in ipairs(perms) do
				local inService = ServiceStates[permName] or false
				local label = inService and "Finalizar Expediente" or "Iniciar Expediente"
				if hasMultiple then
					label = label .. " (" .. permName .. ")"
				end

				table.insert(options, {
					event = "target:Service",
					label = label,
					service = permName,
					tunnel = "proserver"
				})
			end

			if #options > 0 then
				exports.target:AddCircleZone(zoneName, coords, weight, {
					name = zoneName,
					heading = 0.0,
					useZ = true
				}, {
					Distance = distance,
					options = options
				})
				table.insert(ActiveServiceZones, zoneName)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------
-- THREADSERVICE
---------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	TriggerServerEvent("Night_Management:requestServices")
end)
---------------------------------------------------------------------------------------------------------
-- TARGET:UPDATESERVICES
---------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:updateServices")
AddEventHandler("target:updateServices", function(serviceList)
	UpdateServiceZones(serviceList)
end)
---------------------------------------------------------------------------------------------------------
-- SERVICE:CLIENT
---------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Client")
AddEventHandler("service:Client", function(Permission, Status)
	ServiceStates[Permission] = Status

	for Index, v in pairs(Services) do
		local zoneName = "Service:" .. (v.id or Index)
		local perms = ParsePermissions(v.Permission)
		local hasMultiple = #perms > 1
		local containsPerm = false

		for _, p in ipairs(perms) do
			if p == Permission then
				containsPerm = true
				break
			end
		end

		if containsPerm then
			local newOptions = {}
			for _, permName in ipairs(perms) do
				local inService = ServiceStates[permName] or false
				local label = inService and "Finalizar Expediente" or "Iniciar Expediente"
				if hasMultiple then
					label = label .. " (" .. permName .. ")"
				end

				table.insert(newOptions, {
					event = "target:Service",
					label = label,
					service = permName,
					tunnel = "proserver"
				})
			end

			if #newOptions > 0 then
				exports.target:LabelOptions(zoneName, newOptions)
			end
		end
	end
end)