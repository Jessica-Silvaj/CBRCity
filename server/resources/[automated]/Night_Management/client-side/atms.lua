-----------------------------------------------------------------------------------------------------------------------------------------
-- CAIXAS ELETRÔNICOS (painel gestor)
-----------------------------------------------------------------------------------------------------------------------------------------
-- A lista em si chega no bank e no c4 pelo Night_Management:atmsSync (eles pedem com Night_Management:atmsLoad)
local Models = { "prop_atm_01","prop_atm_02","prop_atm_03","prop_fleeca_atm" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAtms",function(Data,Callback)
	TriggerServerEvent("Night_Management:requestAtms")
	Callback("ok")
end)

RegisterNetEvent("Night_Management:updateAtms")
AddEventHandler("Night_Management:updateAtms",function(List)
	SendNUIMessage({ action = "updateAtms", atms = List })
end)

-- Detecta o caixa mais próximo; sem caixa por perto devolve a posição do jogador
RegisterNUICallback("atmHere",function(Data,Callback)
	local Coords = GetEntityCoords(PlayerPedId())
    if Data.kind == "agency" then Callback({ x = Coords.x,y = Coords.y,z = Coords.z }) return end
	local Closest,Model,Distance = nil,nil,3.0

	for _,Name in ipairs(Models) do
		local Object = GetClosestObjectOfType(Coords.x,Coords.y,Coords.z,3.0,GetHashKey(Name),false,false,false)
		if Object ~= 0 then
			local ObjectDistance = #(Coords - GetEntityCoords(Object))
			if ObjectDistance < Distance then
				Closest,Model,Distance = Object,Name,ObjectDistance
			end
		end
	end

	-- Mesma altura usada nas listas antigas (meio do caixa, ~1m acima da base)
	local Result = Closest and GetEntityCoords(Closest) + vec3(0.0,0.0,1.0) or Coords

	if not Model then
		TriggerEvent("Notify","Atenção","Nenhum caixa eletrônico encontrado a até 3 metros. Foi usada a sua posição.","amarelo",5000)
	end

	Callback({ x = Result.x, y = Result.y, z = Result.z, model = Model })
end)

RegisterNUICallback("saveAtm",function(Data,Callback)
	TriggerServerEvent("Night_Management:saveAtm",Data)
	Callback("ok")
end)

RegisterNUICallback("deleteAtm",function(Data,Callback)
	TriggerServerEvent("Night_Management:deleteAtm",Data.id)
	Callback("ok")
end)
