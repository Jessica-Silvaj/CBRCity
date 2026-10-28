-- Function to send messages to the NUI (UI interface)
function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

-- Variable to control menu state
local isMenuActive = false

-- Function to toggle the NUI frame visibility and focus
function toggleNuiFrame(visible)
  isMenuActive = visible
  
  -- Enable/disable cursor and keyboard input
  SetNuiFocus(visible, visible)
  
  if visible then
    SendReactMessage("setTime", { 
      hour = GlobalState.Hours or 12, 
      minute = GlobalState.Minutes or 0 
    })
  end

  -- Send visibility state to UI
  SendReactMessage("setVisible", visible)
end

-- Thread to disable controls while menu is open
CreateThread(function()
  local lastTimeUpdate = 0
  
  while true do
    Wait(0)
    if isMenuActive then
      DisableAllControlActions(0)
      EnableControlAction(0, 1, true) -- Look Left/Right
      EnableControlAction(0, 2, true) -- Look Up/Down
      
      -- Send time to NUI dynamically every 1 second
      local currentTime = GetGameTimer()
      if currentTime - lastTimeUpdate > 1000 then
        lastTimeUpdate = currentTime
        SendReactMessage("setTime", { 
          hour = GlobalState.Hours or 12, 
          minute = GlobalState.Minutes or 0 
        })
      end
    end
  end
end)

-- Register callback to hide the frame when requested from NUI
RegisterNUICallback("hideFrame", function(data, callback)
  toggleNuiFrame(false)
  if callback then callback('ok') end
end)