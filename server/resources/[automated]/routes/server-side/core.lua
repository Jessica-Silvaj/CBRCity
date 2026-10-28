-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("routes",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local RewardItems = {}
local ActiveRoutes = {}
local RouteCost = {}
Config = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE LOAD
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadRoutes()
    Config = {}
    local rows = exports.oxmysql:executeSync("SELECT * FROM routes")
    if rows then
        for _, row in ipairs(rows) do
            local rawList = row.list and json.decode(row.list) or {}
            local validList = {}
            for _, v in ipairs(rawList) do
                local itemIndex = v["Item"] or v["item"] or v["Index"]
                if itemIndex and exports.vrp:ItemExist(itemIndex) then
                    table.insert(validList, v)
                end
            end

            local isRoute = (row.route == 1 or row.route == true or row.route == "1" or row.route == "true")
            local isLoop = (row.loop == 1 or row.loop == true or row.loop == "1" or row.loop == "true")
            local isDebug = (row.debugpoly == 1 or row.debugpoly == true or row.debugpoly == "1" or row.debugpoly == "true")

            local routeConfig = {
                ["Route"] = isRoute,
                ["Loop"] = isLoop,
                ["Circle"] = tonumber(row.circle) or 1.0,
                ["Wanted"] = (row.wanted == 0 or row.wanted == "0") and false or row.wanted,
                ["Battlepass"] = (row.battlepass == 0 or row.battlepass == "0") and false or row.battlepass,
                ["DebugPoly"] = isDebug,
                ["Permission"] = row.permission,
                ["Mode"] = row.mode,
                ["Init"] = nil,
                ["Experience"] = row.experience and json.decode(row.experience) or nil,
                ["List"] = validList,
                ["Coords"] = {}
            }
            
            if row.init then
                local initData = json.decode(row.init)
                if initData then
                    routeConfig["Init"] = vec3(initData.x, initData.y, initData.z)
                end
            end

            if row.coords then
                local coordsData = json.decode(row.coords)
                if coordsData then
                    for _, coord in ipairs(coordsData) do
                        table.insert(routeConfig["Coords"], vec3(coord.x, coord.y, coord.z))
                    end
                end
            end
            
            Config[row.name] = routeConfig
        end
    end
    TriggerClientEvent("routes:ClientSync", -1, Config)
end

CreateThread(function()
    while GetResourceState("oxmysql") ~= "started" do
        Wait(500)
    end
    Wait(1000)
    LoadRoutes()
end)

RegisterNetEvent("Night_Management:requestRoutes")
AddEventHandler("Night_Management:requestRoutes", function()
    local source = source
    if source ~= "" and source ~= nil then return end
    LoadRoutes()
end)

AddEventHandler("Connect", function(Passport, source)
    TriggerClientEvent("routes:ClientSync", source, Config)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deliver()
    local Passport = vRP.Passport(source)	
    if Passport and ActiveRoutes[Passport] then	
        local Active = ActiveRoutes[Passport]
        local Route = Config[Active['Route']]
        if Route then
            local Items = Route['List']		
            RewardItems[Passport] = {}		
            for _, Index in pairs(Active['Items']) do
                local numIdx = tonumber(Index) or Index
                if Items[numIdx] then
                    table.insert(RewardItems[Passport], Items[numIdx])
                end
            end	

            if #RewardItems[Passport] > 0 then
                local RewardAmountItem = 1
                for _ = 1, RewardAmountItem do
                    local Reward = RandPercentage(RewardItems[Passport])
                    if Reward and type(Reward) == "table" and Reward['Item'] then
                        local Item = Reward['Item']
                        local Amount = Reward["Valuation"] or math.random(Reward.Min or 1, Reward.Max or 1)
                        
                        if vRP.MaxItens(Passport, Item, Amount) then
                            TriggerClientEvent("Notify",source,"Aviso","Limite deste item atingido. Sua recompensa caiu no chão.","amarelo",5000)
                            exports.inventory:Drops(Passport,source,Item,Amount)
                        elseif not vRP.CheckWeight(Passport, Item, Amount) then
                            TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
                            exports.inventory:Drops(Passport,source,Item,Amount)
                        else
                            vRP.GenerateItem(Passport, Item, Amount, true)
                        end
                    end
                end			
                if Route['Experience'] then
                    local MaxExperience = 100
                    local Experience = vRP.GetExperience(Passport, Route['Experience']['Name'])
                    local Amount = ((Experience + Route['Experience']['Amount']) <= MaxExperience) and Route['Experience']['Amount'] or (MaxExperience - Experience)
                    vRP.PutExperience(Passport, Route['Experience']['Name'], Amount)
                end
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
    local Passport = vRP.Passport(source)
    if Passport then
        local Route = Config[Name]
        if Route and (not Route["Permission"] or Route["Permission"] == "" or Route["Permission"] == "false" or Route["Permission"] == "0" or vRP.HasPermission(Passport, Route["Permission"])) then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Start(Items, Name)
    local Passport = vRP.Passport(source)	
	if Passport and Config[Name] then
		RouteCost[Passport] = 0		
		for _, Index in pairs(Items) do
			local numIdx = tonumber(Index) or Index
			local Price = (Config[Name]['List'] and Config[Name]['List'][numIdx] and Config[Name]['List'][numIdx]['Price']) or 0
			RouteCost[Passport] = RouteCost[Passport] + Price
		end
		if vRP.PaymentFull(Passport,RouteCost[Passport]) or (RouteCost[Passport] == 0) then
			ActiveRoutes[Passport] = { Route = Name, Items = Items }
			return true
		end
	end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Finish()
    local Passport = vRP.Passport(source)
    if Passport and ActiveRoutes[Passport] then	
		ActiveRoutes[Passport],
		RewardItems[Passport],
		RouteCost[Passport] = nil,nil,nil
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
    if ActiveRoutes[Passport] then
        ActiveRoutes[Passport],
        RewardItems[Passport],
        RouteCost[Passport] = nil,nil,nil
    end
end)