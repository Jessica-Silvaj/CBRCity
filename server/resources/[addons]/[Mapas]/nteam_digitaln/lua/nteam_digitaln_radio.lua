
local resourceName = GetCurrentResourceName()

local radioLocations = {
  {
    origin = vector3(-679.699, -38.8522, 38.42659),
    names = {
      "digitaln_radio_inside",
      "digitaln_radio_outside"
    }
  },
  {
    origin = vector3(2081.78442, 3318.554, 46.057514),
    names = {
      "digitaln_sandy_radio_inside",
      "digitaln_sandy_radio_outside"
    }
  },
  {
    origin = vector3(-304.3526681048877, 6121.638090805476, 31.686122399999995),
    names = {
      "digitaln_paleto_radio_inside",
      "digitaln_paleto_radio_outside"
    }
  }
}

local resourceStopping = false

function SetDigitalnRadioEmitters(radioLocation, enabled)
  for _, emitterName in ipairs(radioLocation.names) do
    SetStaticEmitterEnabled(emitterName, enabled)
  end

  radioLocation.enabled = enabled
end

function GetDigitalnRadioEnabledState(radioLocation, playerCoords)
  local isNearby = #(playerCoords - radioLocation.origin) < 80.0
  local interiorId = 0

  if isNearby then
    interiorId = GetInteriorAtCoordsWithTypehash(
      radioLocation.origin.x,
      radioLocation.origin.y,
      radioLocation.origin.z,
      835341623
    ) or 0
  end

  -- Precisa CHAMAR IsInteriorReady e devolver true/false; antes devolvia a própria função
  -- e o SetStaticEmitterEnabled dava "invalid lua type: function"
  return Config.ShopRadio == true
    and isNearby
    and interiorId ~= 0
    and IsInteriorReady(interiorId) == true
end

CreateThread(function()
  while not resourceStopping do
    local playerCoords = GetEntityCoords(PlayerPedId())

    for _, radioLocation in ipairs(radioLocations) do
      local enabledState = GetDigitalnRadioEnabledState(radioLocation, playerCoords)

      if enabledState or radioLocation.enabled then
        SetDigitalnRadioEmitters(radioLocation, enabledState)
      end
    end

    Wait(1000)
  end
end)

AddEventHandler("onResourceStop", function(stoppedResourceName)
  if stoppedResourceName ~= resourceName then
    return
  end

  resourceStopping = true

  for _, radioLocation in ipairs(radioLocations) do
    SetDigitalnRadioEmitters(radioLocation, false)
  end
end)
