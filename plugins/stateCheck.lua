local function checkAutoLaunch()
  local isLaunch = hs.autoLaunch()
  if isLaunch == false then
    hs.autoLaunch(not isLaunch)
    hs.alert('hammerspoon is autoLaunch')
  end
  -- local isDock = hs.dockIcon()
  -- if isDock == true then
  --   hs.dockIcon(not isDock)
  -- end
end

local function toggleConsole()
  hs.hotkey.bind({'cmd', 'option', 'shift'}, 'c', function()
    local state = hs.dockIcon()
    hs.dockIcon(not state)
  end)
end

checkAutoLaunch()
toggleConsole()
