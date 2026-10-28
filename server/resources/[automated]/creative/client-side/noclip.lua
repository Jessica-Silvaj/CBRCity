-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local NoClip = false
local PlayerPed = nil
local PlayerVehicle = 0
local NoClipEntity = nil
local ShowButtons = true
local ButtonsShown = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISCONTROLALWAYSPRESSED
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsControlAlwaysPressed(Input,Control)
	return IsControlPressed(Input,Control) or IsDisabledControlPressed(Input,Control)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCAMDIRECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCamDirections()
	local Pitch = GetGameplayCamRelativePitch()
	local Heading = GetEntityHeading(NoClipEntity)
	local Calculate = GetGameplayCamRelativeHeading() + Heading

	local x = -math.sin(Calculate * math.pi / 180.0)
	local y = math.cos(Calculate * math.pi / 180.0)
	local z = math.sin(Pitch * math.pi / 180.0)

	local Len = math.sqrt(x * x + y * y + z * z)
	if Len ~= 0 then
		x,y,z = x / Len,y / Len,z / Len
	end

	SetEntityHeading(NoClipEntity,Calculate)

	return vec3(x,y,z)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWNOCLIPBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function ShowNoClipButtons()
	if ButtonsShown then return end
	ButtonsShown = true

	local DefaultButtons = {
		{ Letter = "W", Text = "Mover para frente" },
		{ Letter = "S", Text = "Mover para trás" },
		{ Letter = "A", Text = "Mover para esquerda" },
		{ Letter = "D", Text = "Mover para direita" },
		{ Letter = "Q", Text = "Subir" },
		{ Letter = "E", Text = "Descer" },
		{ Letter = "⇧", Text = "Aumentar velocidade (Shift)" },
		{ Letter = "H", Text = "Esconder opções" }
	}

	TriggerEvent("inventory:Buttons", DefaultButtons)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HIDENOCLIPBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function HideNoClipButtons()
	if not ButtonsShown then return end
	ButtonsShown = false
	TriggerEvent("inventory:CloseButtons")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUNNOCLIPTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
local function RunNoClipThread()
	CreateThread(function()
		while NoClip do
			Wait(0)

			local Change = false
			local Direction = GetCamDirections()
			local Coords = GetEntityCoords(NoClipEntity)
			local x,y,z = table.unpack(Coords)
			local Multiplier = IsControlAlwaysPressed(0,21) and 5.0 or 1.0

			-- Q (44), E (38) e H (74) ficam só para o noclip enquanto ele estiver ligado
			DisableControlAction(0,44,true)
			DisableControlAction(0,38,true)
			DisableControlAction(0,74,true)

			if IsDisabledControlJustPressed(0,74) then
				ShowButtons = not ShowButtons

				if ShowButtons then
					ShowNoClipButtons()
				else
					HideNoClipButtons()
				end
			end

			if IsControlAlwaysPressed(0,21) then
				Multiplier = 5.0
			end

			if IsControlAlwaysPressed(0,32) then
				x = x + Multiplier * Direction.x
				y = y + Multiplier * Direction.y
				z = z + Multiplier * Direction.z
				Change = true
			end

			if IsControlAlwaysPressed(0,33) then
				x = x - Multiplier * Direction.x
				y = y - Multiplier * Direction.y
				z = z - Multiplier * Direction.z
				Change = true
			end

			if IsControlAlwaysPressed(0,34) then
				x = x - Multiplier * Direction.y
				y = y + Multiplier * Direction.x
				Change = true
			end

			if IsControlAlwaysPressed(0,35) then
				x = x + Multiplier * Direction.y
				y = y - Multiplier * Direction.x
				Change = true
			end

			-- Q: subir
			if IsControlAlwaysPressed(0,44) then
				z = z + Multiplier * 0.25
				Change = true
			end

			-- E: descer
			if IsControlAlwaysPressed(0,38) then
				z = z - Multiplier * 0.25
				Change = true
			end

			if Change then
				SetEntityCoordsNoOffset(NoClipEntity,x,y,z)
			end

			if PlayerVehicle ~= 0 then
				BlockWeaponWheelThisFrame()
				SetVehicleEngineOn(NoClipEntity,false,true,true)
			end
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATIVE:NOCLIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Creative:NoClip")
AddEventHandler("Creative:NoClip",function()
	NoClip = not NoClip
	PlayerPed = PlayerPedId()
	PlayerVehicle = GetVehiclePedIsUsing(PlayerPed)
	NoClipEntity = PlayerVehicle ~= 0 and PlayerVehicle or PlayerPed

	if NoClip then
		if ShowButtons then
			ShowNoClipButtons()
		end
		SetEntityCompletelyDisableCollision(NoClipEntity,false,false)
		SetEntityCollision(NoClipEntity,false,false)
		FreezeEntityPosition(NoClipEntity,true)
		SetEntityInvincible(NoClipEntity,true)
		SetEntityVisible(NoClipEntity,false)

		RunNoClipThread()
	else
		HideNoClipButtons()
		SetEntityCompletelyDisableCollision(NoClipEntity,true,true)
		SetEntityCollision(NoClipEntity,true,true)
		FreezeEntityPosition(NoClipEntity,false)
		SetEntityInvincible(NoClipEntity,false)
		SetEntityVisible(NoClipEntity,true)
	end
end)