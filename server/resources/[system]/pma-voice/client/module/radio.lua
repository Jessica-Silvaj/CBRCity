local radioChannel = 0
local radioNames = {}
local RadioProp = nil

function isRadioEnabled()
	return radioEnabled and LocalPlayer.state.disableRadio == 0
end

function syncRadioData(radioTable,localPlyRadioName)
	radioData = radioTable

	local isEnabled = isRadioEnabled()

	if isEnabled then
		handleRadioAndCallInit()
	end

	radioNames[playerServerId] = localPlyRadioName
end

RegisterNetEvent("pma-voice:syncRadioData",syncRadioData)

function setTalkingOnRadio(plySource,enabled,Name)
	radioData[plySource] = enabled
	TriggerEvent("radio:Display",plySource,Name,enabled)

	if not isRadioEnabled() then return end

	local enabled = enabled or callData[plySource]
	toggleVoice(plySource,enabled,"radio")
end
RegisterNetEvent("pma-voice:setTalkingOnRadio",setTalkingOnRadio)

function addPlayerToRadio(plySource,plyRadioName)
	radioData[plySource] = false
	radioNames[plySource] = plyRadioName

	if radioPressed then
		addVoiceTargets(radioData,callData)
	end
end
RegisterNetEvent("pma-voice:addPlayerToRadio",addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		for tgt,_ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt,false,"radio")
			end
		end

		radioNames = {}
		radioData = {}

		addVoiceTargets(callData)
	else
		toggleVoice(plySource,false,"radio")

		if radioPressed then
			addVoiceTargets(radioData,callData)
		end

		radioData[plySource] = nil
		radioNames[plySource] = nil
	end
end
RegisterNetEvent("pma-voice:removePlayerFromRadio",removePlayerFromRadio)

RegisterNetEvent("pma-voice:radioChangeRejected",function()
	radioChannel = 0
end)

function setRadioChannel(channel)
	radioEnabled = true
	type_check({ channel,"number" })
	TriggerServerEvent("pma-voice:setPlayerRadio",channel)
	radioChannel = tonumber(channel)

	sendUIMessage({ radioChannel = channel, radioEnabled = radioEnabled })
end

exports("setRadioChannel",setRadioChannel)
exports("SetRadioChannel",setRadioChannel)

exports("removePlayerFromRadio",function()
	radioEnabled = false
	setRadioChannel(0)
end)

exports("addPlayerToRadio",function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

local radioanim = "1"

RegisterNetEvent("radio:GetRadio")
AddEventHandler("radio:GetRadio",function()
	radioanim = exports["radio"]:pmaradioanim()
end)

RegisterNetEvent("radio:setAnimacao")
AddEventHandler("radio:setAnimacao",function(animacao)
	radioanim = tostring(animacao)
end)

RegisterCommand("+radiotalk",function()
	local Ped = PlayerPedId()
	if IsPedSwimming(Ped) or GetEntityHealth(Ped) <= 100 or LocalPlayer["state"]["Handcuff"] or IsPlayerFreeAiming(PlayerId()) or not isRadioEnabled() then
		return
	end

	if GetResourceState("radio") == "started" then
		radioanim = exports["radio"]:pmaradioanim()
	end

	if not radioPressed then
		if radioChannel > 0 then
			addVoiceTargets(radioData,callData)
			TriggerServerEvent("pma-voice:setTalkingOnRadio",true)
			TriggerServerEvent('pessoafalando',true,radioChannel)
			radioPressed = true
			playMicClicks(true)

			if radioanim == "1" then
				RequestAnimDict("random@arrests")
				while not HasAnimDictLoaded("random@arrests") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "random@arrests", "generic_radio_chatter", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "2" then
				RequestAnimDict("anim@male@holding_radio")
				while not HasAnimDictLoaded("anim@male@holding_radio") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "anim@male@holding_radio", "holding_radio_clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 28422), 0.0750, 0.0230, -0.0230, -90.0000, 0.0, -59.9999, 1, 0, 0, 0, 2, 1)
			elseif radioanim == "3" then
				RequestAnimDict("pazeee@radiog@animations")
				while not HasAnimDictLoaded("pazeee@radiog@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiog@animations", "pazeee@radiog@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "4" then
				RequestAnimDict("pazeee@radioh@animations")
				while not HasAnimDictLoaded("pazeee@radioh@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioh@animations", "pazeee@radioh@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "5" then
				RequestAnimDict("pazeee@radiok@animations")
				while not HasAnimDictLoaded("pazeee@radiok@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiok@animations", "pazeee@radiok@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "6" then
				RequestAnimDict("pazeee@radiol@animations")
				while not HasAnimDictLoaded("pazeee@radiol@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiol@animations", "pazeee@radiol@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "7" then
				RequestAnimDict("pazeee@radiom@animations")
				while not HasAnimDictLoaded("pazeee@radiom@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiom@animations", "pazeee@radiom@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "8" then
				RequestAnimDict("pazeee@radion@animations")
				while not HasAnimDictLoaded("pazeee@radion@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radion@animations", "pazeee@radion@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "9" then
				RequestAnimDict("pazeee@radioo@animations")
				while not HasAnimDictLoaded("pazeee@radioo@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioo@animations", "pazeee@radioo@clip", 8.0, 0.0, -1, 49, 0, 0, 0, 0)
			elseif radioanim == "10" then
				RequestAnimDict("pazeee@radioa@animations")
				while not HasAnimDictLoaded("pazeee@radioa@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioa@animations", "pazeee@radioa@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 57005), 0.160, 0.060, -0.010, -119.52, -157.824, 46.041, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "11" then
				RequestAnimDict("pazeee@radiob@animations")
				while not HasAnimDictLoaded("pazeee@radiob@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiob@animations", "pazeee@radiob@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 18905), 0.141, 0.066, 0.0110, -120.8, -33.752, -32.259, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "12" then
				RequestAnimDict("pazeee@radioc@animations")
				while not HasAnimDictLoaded("pazeee@radioc@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioc@animations", "pazeee@radioc@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 57005), 0.160, 0.060, 0.0, -119.52, -157.824, 46.041, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "13" then
				RequestAnimDict("pazeee@radiod@animations")
				while not HasAnimDictLoaded("pazeee@radiod@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiod@animations", "pazeee@radiod@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 18905), 0.154, 0.067, 0.010, -120.8, -33.752, -32.259, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "14" then
				RequestAnimDict("pazeee@radioe@animations")
				while not HasAnimDictLoaded("pazeee@radioe@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioe@animations", "pazeee@radioe@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 57005), 0.160, 0.060, 0.0, -119.52, -157.824, 46.041, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "15" then
				RequestAnimDict("pazeee@radiof@animations")
				while not HasAnimDictLoaded("pazeee@radiof@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiof@animations", "pazeee@radiof@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 18905), 0.154, 0.067, 0.010, -120.8, -33.752, -32.259, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "16" then
				RequestAnimDict("pazeee@radioi@animations")
				while not HasAnimDictLoaded("pazeee@radioi@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioi@animations", "pazeee@radioi@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 57005), 0.160, 0.060, 0.0, -119.52, -157.824, 46.041, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "17" then
				RequestAnimDict("pazeee@radioj@animations")
				while not HasAnimDictLoaded("pazeee@radioj@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radioj@animations", "pazeee@radioj@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 57005), 0.160, 0.060, 0.0, -119.52, -157.824, 46.041, 1, 0, 0, 0, 1, 1)
			elseif radioanim == "18" then
				RequestAnimDict("pazeee@radiop@animations")
				while not HasAnimDictLoaded("pazeee@radiop@animations") do Citizen.Wait(1) end
				TaskPlayAnim(Ped, "pazeee@radiop@animations", "pazeee@radiop@clip", 4.0, 4.0, -1, 49, 0, 0, 0, 0)
				RadioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
				AttachEntityToEntity(RadioProp, Ped, GetPedBoneIndex(Ped, 60309), 0.120, 0.050, 0.190, -59.618, -30.381, -72.701, 1, 0, 0, 0, 1, 1)
			end

			CreateThread(function()
				TriggerEvent("pma-voice:radioActive",true)
				LocalPlayer.state:set("radioActive",true,true)
				local checkFailed = false

				while radioPressed do
					local Ped = PlayerPedId()
					if radioChannel < 0 or GetEntityHealth(Ped) <= 100 or not isRadioEnabled() then
						checkFailed = true
						break
					end

					SetControlNormal(0,249,1.0)
					SetControlNormal(1,249,1.0)
					SetControlNormal(2,249,1.0)
					DisableControlAction(0,24,true)
					DisableControlAction(0,25,true)
					DisableControlAction(0,257,true)
					DisableControlAction(0,140,true)
					DisableControlAction(0,142,true)

					Wait(0)
				end

				if checkFailed then
					ExecuteCommand("-radiotalk")
				end
			end)
		end
	end
end,false)

RegisterCommand("-radiotalk",function()
	if radioChannel > 0 and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		addVoiceTargets(callData)
		TriggerEvent("pma-voice:radioActive",false)
		LocalPlayer.state:set("radioActive",false,true)
		TriggerServerEvent('pessoafalando',false,radioChannel)
		playMicClicks(false)

		local ped = PlayerPedId()
		if radioanim == "1" then StopAnimTask(ped, "random@arrests", "generic_radio_chatter", -4.0)
		elseif radioanim == "2" then StopAnimTask(ped, "anim@male@holding_radio", "holding_radio_clip", -4.0)
		elseif radioanim == "3" then StopAnimTask(ped, "pazeee@radiog@animations", "pazeee@radiog@clip", -4.0)
		elseif radioanim == "4" then StopAnimTask(ped, "pazeee@radioh@animations", "pazeee@radioh@clip", -4.0)
		elseif radioanim == "5" then StopAnimTask(ped, "pazeee@radiok@animations", "pazeee@radiok@clip", -4.0)
		elseif radioanim == "6" then StopAnimTask(ped, "pazeee@radiol@animations", "pazeee@radiol@clip", -4.0)
		elseif radioanim == "7" then StopAnimTask(ped, "pazeee@radiom@animations", "pazeee@radiom@clip", -4.0)
		elseif radioanim == "8" then StopAnimTask(ped, "pazeee@radion@animations", "pazeee@radion@clip", -4.0)
		elseif radioanim == "9" then StopAnimTask(ped, "pazeee@radioo@animations", "pazeee@radioo@clip", -4.0)
		elseif radioanim == "10" then StopAnimTask(ped, "pazeee@radioa@animations", "pazeee@radioa@clip", -4.0)
		elseif radioanim == "11" then StopAnimTask(ped, "pazeee@radiob@animations", "pazeee@radiob@clip", -4.0)
		elseif radioanim == "12" then StopAnimTask(ped, "pazeee@radioc@animations", "pazeee@radioc@clip", -4.0)
		elseif radioanim == "13" then StopAnimTask(ped, "pazeee@radiod@animations", "pazeee@radiod@clip", -4.0)
		elseif radioanim == "14" then StopAnimTask(ped, "pazeee@radioe@animations", "pazeee@radioe@clip", -4.0)
		elseif radioanim == "15" then StopAnimTask(ped, "pazeee@radiof@animations", "pazeee@radiof@clip", -4.0)
		elseif radioanim == "16" then StopAnimTask(ped, "pazeee@radioi@animations", "pazeee@radioi@clip", -4.0)
		elseif radioanim == "17" then StopAnimTask(ped, "pazeee@radioj@animations", "pazeee@radioj@clip", -4.0)
		elseif radioanim == "18" then StopAnimTask(ped, "pazeee@radiop@animations", "pazeee@radiop@clip", -4.0)
		end

		TriggerServerEvent("pma-voice:setTalkingOnRadio",false)

		if RadioProp and DoesEntityExist(RadioProp) then
			DeleteObject(RadioProp)
			RadioProp = nil
		end
	end
end,false)

RegisterKeyMapping("+radiotalk","Dialogar no rádio.","keyboard","CAPITAL")

function syncRadio(_radioChannel)
	radioChannel = tonumber(Channel)
end
RegisterNetEvent("pma-voice:clSetPlayerRadio",syncRadio)

function handleRadioEnabledChanged(wasRadioEnabled)
	if wasRadioEnabled then
		syncRadioData(radioData,"")
	else
		removePlayerFromRadio(playerServerId)
	end
end

local function addRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0
	curVal = curVal | bit
	LocalPlayer.state:set("disableRadio",curVal,true)
end
exports("addRadioDisableBit",addRadioDisableBit)

local function removeRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0
	curVal = curVal & (~bit)
	LocalPlayer.state:set("disableRadio",curVal,true)
end
exports("removeRadioDisableBit",removeRadioDisableBit)
