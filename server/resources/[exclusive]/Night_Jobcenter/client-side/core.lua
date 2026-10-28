-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("Night_Jobcenter",Creative)
vSERVER = Tunnel.getInterface("Night_Jobcenter")
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBCENTER:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Jobcenter:Open", function(config)
	if not IsPauseMenuActive() then
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] then
			if not LocalPlayer["state"]["Work"] then
				vRP.CreateObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "prop_cs_tablet", 49, 28422, -0.05, 0.0, 0.0, 0.0, 0.0, 0.0)
				SendNUIMessage( { type = "open", config = config } )
				SetNuiFocus(true, true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTJOB
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("startJob", function(data, cb)
	TriggerServerEvent("Night_Jobcenter:StartJob", data["rank"])
	SetNuiFocus(false, false)
	vRP.Destroy()
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(data, cb)
	SetNuiFocus(false, false)
	vRP.Destroy()
	cb("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBCENTER:GPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Night_Jobcenter:GPS", function(job)
	for Name,v in pairs(Coords) do
		if v["Name"] == job then
			SetNewWaypoint(v["X"], v["Y"])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	exports["target"]:AddCircleZone("Night_Jobcenter", vec3(-269.36, -955.38, 31.22), 0.5, {
		name = "Night_Jobcenter",
		heading = 0.0
	}, {
		Distance = 1.5,
		options = {
			{
				event = "Night_Jobcenter:OpenJobCenter",
				label = "Abrir Central",
				tunnel = "server"
			},{
				event = "Night_Jobcenter:Solicitar",
				label = "Solicitar Carteira de Trabalho",
				tunnel = "server"
			}
		}
	})
end)-----------------------------------------------------------------------------------------------------------------------------------------
-- SAIRDOEMPREGO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("SairDoEmprego",function()
	if IsPauseMenuActive() or LocalPlayer.state.Commands or LocalPlayer.state.Handcuff then
		return
	end

	if not LocalPlayer.state.Job then
		TriggerEvent("Notify","Atenção","Você não tem nenhum emprego assinado no momento.","amarelo",5000)
		return
	end

	TriggerServerEvent("Night_Jobcenter:StartJob","Sair")
end)


RegisterKeyMapping("SairDoEmprego","Sair do emprego atual.","keyboard","F5")
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVISO F5
-----------------------------------------------------------------------------------------------------------------------------------------
-- Vale para todos os empregos: avisa ao assinar a carteira (ou ao entrar já empregado) como sair pelo F5
AddStateBagChangeHandler("Job",("player:%s"):format(GetPlayerServerId(PlayerId())),function(_,_,Value)
	if Value then
		local Name = (Works and Works[Value]) or Value
		TriggerEvent("Notify","Central de Empregos","Você está empregado como <b>"..Name.."</b>. Para sair do emprego, aperte <b>F5</b>.","default",8000)
	end
end)
