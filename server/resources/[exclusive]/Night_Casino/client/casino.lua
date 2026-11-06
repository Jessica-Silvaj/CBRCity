local inCasino = false

function IsTable(T)
	return type(T) == 'table'
end

function SetIplPropState(interiorId, props, state, refresh)
	if refresh == nil then refresh = false end
	if IsTable(interiorId) then
		for key, value in pairs(interiorId) do
			SetIplPropState(value, props, state, refresh)
		end
	else
		if IsTable(props) then
			for key, value in pairs(props) do
				SetIplPropState(interiorId, value, state, refresh)
			end
		else
			if state then
				if not IsInteriorPropEnabled(interiorId, props) then EnableInteriorProp(interiorId, props) end
			else
				if IsInteriorPropEnabled(interiorId, props) then DisableInteriorProp(interiorId, props) end
			end
		end
		if refresh == true then RefreshInterior(interiorId) end
	end
end
  
Citizen.CreateThread(function()
	Wait(0)
	RequestIpl('vw_casino_main')
	RequestIpl('vw_dlc_casino_door')
	RequestIpl('hei_dlc_casino_door')
	RequestIpl("hei_dlc_windows_casino")
	RequestIpl("vw_casino_penthouse")
	SetIplPropState(274689, "Set_Pent_Tint_Shell", true, true)
	SetInteriorEntitySetColor(274689, "Set_Pent_Tint_Shell", 3)
	RequestIpl("hei_dlc_windows_casino_lod")
	RequestIpl("vw_casino_carpark")
	RequestIpl("vw_casino_garage")
	RequestIpl("hei_dlc_casino_aircon")
	RequestIpl("hei_dlc_casino_aircon_lod")
	RequestIpl("hei_dlc_casino_door")
	RequestIpl("hei_dlc_casino_door_lod")
	RequestIpl("hei_dlc_vw_roofdoors_locked")
	RequestIpl("vw_ch3_additions")
	RequestIpl("vw_ch3_additions_long_0")
	RequestIpl("vw_ch3_additions_strm_0")
	RequestIpl("vw_dlc_casino_door")
	RequestIpl("vw_dlc_casino_door_lod")
	RequestIpl("vw_casino_billboard")
	RequestIpl("vw_casino_billboard_lod(1)")
	RequestIpl("vw_casino_billboard_lod")
	RequestIpl("vw_int_placement_vw")
	RequestIpl("vw_dlc_casino_apart")
	
	local interiorID = GetInteriorAtCoords(1100.000, 220.000, -50.000)
	
	if IsValidInterior(interiorID) then
		RefreshInterior(interiorID)
	end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - vector3(1111.0, 230.0, -49.0))
        if dist <= 100.0 then
            enterCasino(true)
        else
            enterCasino(false)
        end
        Citizen.Wait(2000)
    end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function enterCasino(pIsInCasino, pFromElevator, pCoords, pHeading)
	if pIsInCasino == inCasino then return end
	inCasino = pIsInCasino
	Wait(500)
	showDiamondsOnScreenBaby()
	playSomeBackgroundAudioBaby()
end

-- Casino Screens
local Playlists = {
	"CASINO_DIA_PL", -- diamonds
	"CASINO_SNWFLK_PL", -- snowflakes
	"CASINO_WIN_PL", -- win
	"CASINO_HLW_PL", -- skull
}
 
-- Render
function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
  
	return handle
end

-- render tv 
function showDiamondsOnScreenBaby()
	Citizen.CreateThread(function()
	  local model = GetHashKey("vw_vwint01_video_overlay")
	  local timeout = 21085 -- 5000 / 255
  
	  local handle = CreateNamedRenderTargetForModel("CasinoScreen_01", model)
  
	  RegisterScriptWithAudio(0)
	  SetTvChannel(-1)
	  SetTvVolume(-100.0)
	  SetTvAudioFrontend(false)
	  SetScriptGfxDrawOrder(4)
	  SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
	  SetTvChannel(2)
	  SetTvVolume(-100.0)
	  SetTvAudioFrontend(false)
	  EnableMovieSubtitles(1)
  
	function doAlpha()
		Citizen.SetTimeout(timeout, function()
		SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
		SetTvChannel(2)
		SetTvVolume(-100.0)
		SetTvAudioFrontend(false)
		doAlpha()
		end)
	end
	doAlpha()
  
	Citizen.CreateThread(function()
	while inCasino do
	  SetTextRenderId(handle)
	  DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
	  SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	  Citizen.Wait(0)
	end
	SetTvChannel(-1)
	ReleaseNamedRendertarget(GetHashKey("CasinoScreen_01"))
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end)
   end)
end
  
function playSomeBackgroundAudioBaby()
	Citizen.CreateThread(function()
	  local function audioBanks()
		while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
		  Citizen.Wait(0)
		end
	  end
	  audioBanks()
	  while inCasino do
		if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
		  PlayStreamFromPosition(1111, 230, -47)
		end
		if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
		  StartAudioScene("DLC_VW_Casino_General")
		end
		Citizen.Wait(1000)
	  end
	  if IsStreamPlaying() then
		StopStream()
	  end
	  if IsAudioSceneActive("DLC_VW_Casino_General") then
		StopAudioScene("DLC_VW_Casino_General")
	  end
	end)
end