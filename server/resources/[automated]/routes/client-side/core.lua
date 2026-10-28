-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("routes")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Initial = {}
local Selectedz = 1
local Actived = false
local Progress = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG LOAD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("routes:ClientSync")
AddEventHandler("routes:ClientSync", function(serverConfig)
	if Initial then
		for Name in pairs(Initial) do
			exports.target:RemCircleZone("Routes:"..Name)
		end
	end
	Initial = serverConfig
    Config = serverConfig

	for Name in pairs(serverConfig) do
		local filteredList = {}
		for _,v in pairs(Initial[Name]["List"]) do
			local itemIndex = v["Item"] or v["item"] or v["Index"]
			if itemIndex and exports.vrp:ItemExist(itemIndex) then
				table.insert(filteredList, {
					["Index"] = itemIndex,
					["Name"] = exports.vrp:ItemName(itemIndex),
					["Price"] = v["Price"],
					["Active"] = false
				})
			end
		end
		Initial[Name]["List"] = filteredList

		if Initial[Name]["Init"] and Initial[Name]["Circle"] then
			exports.target:AddCircleZone("Routes:"..Name,Initial[Name]["Init"],Initial[Name]["Circle"],{
				name = "Routes:"..Name,
				heading = 0.0,
				useZ = true,
				debugPoly = Initial[Name]["DebugPoly"]
			},{
				shop = Name,
				Distance = 2.0,
				options = {
					{
						event = "routes:Open",
						label = "Abrir",
						tunnel = "client",
						Name = Name
					}
				}
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUTES:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("routes:Open")
AddEventHandler("routes:Open",function(...)
	local args = {...}
	local Name = nil
	for _, arg in ipairs(args) do
		if type(arg) == "table" then
			if arg.Name then Name = arg.Name end
			if arg.shop then Name = arg.shop end
		elseif type(arg) == "string" and Initial[arg] then
			Name = arg
		end
	end
	if not Name and type(args[1]) == "string" then Name = args[1] end

	if not Name or not Initial[Name] then return end

	if not Progress or (Progress and Progress == Name) then
		if vSERVER.Permission(Name) then
			SetNuiFocus(true,true)
			SendNUIMessage({ Action = "Open", Payload = { Progress and true or false,Actived or Initial[Name]["List"],Name } })
		end
	else
		TriggerEvent("Notify","Atenção","Volte no emprego de <b>"..Progress.."</b> e finalize o mesmo.","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Start",function(Data,Callback)
	Progress = Data["Name"]

	if Initial[Progress] then
		Selectedz = 1
		Actived = Initial[Progress]["List"]
		BlipMarkerService()
	end

	for Index,Number in pairs(Data["Items"]) do
		if Actived and Actived[Number] then
			Actived[Number]["Active"] = true
		end
	end

	Callback(vSERVER.Start(Data["Items"],Progress))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Finish",function(Data,Callback)
	if vSERVER.Finish() then
		Actived = false
		Progress = false

		if Blip and DoesBlipExist(Blip) then
			RemoveBlip(Blip)
			Blip = nil
		end
	end

	Callback(Progress and true or false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Progress then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)
				local Distance = #(Coords - Initial[Progress]["Coords"][Selectedz])

				if Distance <= 10.0 then
					TimeDistance = 1
					SetDrawOrigin(Initial[Progress]["Coords"][Selectedz]["x"],Initial[Progress]["Coords"][Selectedz]["y"],Initial[Progress]["Coords"][Selectedz]["z"])
					DrawSprite("TargetTextures","H",0.0,0.0,0.02,0.02 * GetAspectRatio(false),0.0,255,255,255,255)
					ClearDrawOrigin()

					if Distance <= 1.0 and IsControlJustPressed(1,74) then
						LocalPlayer.state.Cancel = true
						LocalPlayer.state.Buttons = true
						TriggerEvent("Progress","Coletando",5000)
						vRP.playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
						Wait(5000)
						vRP.Destroy()
						LocalPlayer.state.Cancel = false
						LocalPlayer.state.Buttons = false

						vSERVER.Deliver()
						if Progress and Initial[Progress] then
							local routeData = Initial[Progress]
							local totalCoords = (routeData["Coords"] and #routeData["Coords"]) or 0
							local isSequential = (routeData["Route"] == true or routeData["Route"] == 1 or routeData["Route"] == "1" or routeData["Route"] == "true")
							local isLoop = (routeData["Loop"] == true or routeData["Loop"] == 1 or routeData["Loop"] == "1" or routeData["Loop"] == "true")

							if totalCoords > 0 then
								if isSequential then
									if Selectedz >= totalCoords then
										if isLoop then
											Selectedz = 1
											BlipMarkerService()
										else
											vSERVER.Finish()
											Actived = false
											Progress = false
											if Blip and DoesBlipExist(Blip) then
												RemoveBlip(Blip)
												Blip = nil
											end
											TriggerEvent("Notify","Sucesso","Você finalizou sua rota. Retorne para iniciar uma nova!","sucesso",5000)
										end
									else
										Selectedz = Selectedz + 1
										BlipMarkerService()
									end
								else
									if isLoop then
										local Lasted = Selectedz
										if totalCoords > 1 then
											repeat
												Selectedz = math.random(totalCoords)
												Wait(1)
											until Lasted ~= Selectedz
										end
										BlipMarkerService()
									else
										if Selectedz >= totalCoords then
											vSERVER.Finish()
											Actived = false
											Progress = false
											if Blip and DoesBlipExist(Blip) then
												RemoveBlip(Blip)
												Blip = nil
											end
											TriggerEvent("Notify","Sucesso","Você finalizou sua rota. Retorne para iniciar uma nova!","sucesso",5000)
										else
											Selectedz = Selectedz + 1
											BlipMarkerService()
										end
									end
								end
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPMARKERSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function BlipMarkerService()
	if Blip and DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end

	if Progress and Initial[Progress] and Initial[Progress]["Coords"] and Initial[Progress]["Coords"][Selectedz] then
		local coords = Initial[Progress]["Coords"][Selectedz]
		Blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		SetBlipSprite(Blip,1)
		SetBlipColour(Blip,77)
		SetBlipScale(Blip,0.5)
		SetBlipRoute(Blip,true)
		SetBlipAsShortRange(Blip,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Entrega")
		EndTextCommandSetBlipName(Blip)
	end
end