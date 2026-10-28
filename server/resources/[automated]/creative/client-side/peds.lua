-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawned = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {}

RegisterNetEvent("creative:updateFromAdmin")
AddEventHandler("creative:updateFromAdmin", function(blips, npcs)
	for Number, ped in pairs(Spawned) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
	Spawned = {}
	List = {}

	if npcs then
		for _, v in pairs(npcs) do
			table.insert(List, {
				Distance = v.Distance or 50,
				Route = v.Route,
				Coords = vec4(v.X, v.Y, v.Z, v.H),
				Model = v.Model,
				Collision = v.Collision,
				Anim = (v.AnimDict and v.AnimName) and {v.AnimDict, v.AnimName} or nil
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number = 1,#List do
			local Distance = #(Coords - List[Number].Coords.xyz)
			if Distance <= List[Number].Distance and (not List[Number].Route or List[Number].Route == LocalPlayer.state.Route) then
				if not Spawned[Number] and LoadModel(List[Number].Model) then
					Spawned[Number] = CreatePed(26,List[Number].Model,List[Number].Coords.x,List[Number].Coords.y,List[Number].Coords.z - 1,List[Number].Coords.w,false,false)

					SetEntityInvincible(Spawned[Number],true)
					FreezeEntityPosition(Spawned[Number],true)
					DecorSetBool(Spawned[Number],"CREATIVE_PED",true)
					SetEntityAsMissionEntity(Spawned[Number],true,true)
					SetBlockingOfNonTemporaryEvents(Spawned[Number],true)

					if not List[Number].Collision then
						SetEntityNoCollisionEntity(Spawned[Number],Ped,false)
					end

					if List[Number].Anim and LoadAnim(List[Number].Anim[1]) then
						TaskPlayAnim(Spawned[Number],List[Number].Anim[1],List[Number].Anim[2],8.0,8.0,-1,1,0,0,0,0)
					end
				end
			else
				if Spawned[Number] then
					if DoesEntityExist(Spawned[Number]) then
						DeleteEntity(Spawned[Number])
					end

					Spawned[Number] = nil
				end
			end
		end

		Wait(1000)
	end
end)