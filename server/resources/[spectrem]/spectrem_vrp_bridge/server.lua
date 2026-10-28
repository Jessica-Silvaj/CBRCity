local BridgeVRP = module("vrp","lib/Proxy").getInterface("vRP")
local Granted = {}
local Principal = "group.spectrem_vrp"

local function Revoke(Source)
	if Granted[Source] then
		ExecuteCommand(("remove_principal player.%d %s"):format(Source,Principal))
		Granted[Source] = nil
	end
end

local function Sync(Source)
	Source = tonumber(Source)
	if not Source or Source <= 0 then return end
	local Passport = BridgeVRP.Passport(Source)
	local Allowed = Passport and BridgeVRP.HasPermission(Passport,"Admin")
	if Allowed then
		if not Granted[Source] then
			ExecuteCommand(("add_principal player.%d %s"):format(Source,Principal))
		end
		Granted[Source] = Passport
	else
		Revoke(Source)
	end
end

AddEventHandler("Connect",function(Passport,Source) Sync(Source) end)
AddEventHandler("Disconnect",function(Passport,Source)
	if Source then Revoke(tonumber(Source)) end
end)
AddEventHandler("playerDropped",function() Revoke(source) end)
AddEventHandler("onResourceStop",function(Resource)
	if Resource == GetCurrentResourceName() then
		for Source in pairs(Granted) do Revoke(Source) end
	end
end)

CreateThread(function()
	while true do
		for _,Source in ipairs(GetPlayers()) do Sync(Source) end
		Wait(5000)
	end
end)

-- Diagnóstico restrito ao console: não mostra nomes nem identificadores pessoais.
RegisterCommand("spectrem_acesso",function(Source)
	if Source ~= 0 then return end
	for _,PlayerSource in ipairs(GetPlayers()) do
		local Id = tonumber(PlayerSource)
		Sync(Id)
		local Passport = BridgeVRP.Passport(Id)
		local Admin = Passport and BridgeVRP.HasPermission(Passport,"Admin") and true or false
		print(("[spectrem_vrp_bridge] ID %d: Admin vRP=%s, acesso Director=%s"):format(Id,tostring(Admin),tostring(IsPlayerAceAllowed(Id,"spectrem_director.use"))))
	end
end,true)
