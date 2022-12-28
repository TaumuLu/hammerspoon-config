local function checkAutoLaunch()
  local isLaunch = hs.autoLaunch()
  if isLaunch == false then
    hs.autoLaunch(not isLaunch)
    hs.alert('hammerspoon is autoLaunch')
  end
end

local function initSetting()
  hs.menuIcon(true)
  hs.consoleOnTop(false)
  hs.accessibilityState()

  checkAutoLaunch()
end

local function toggleConsole()
    local state = hs.dockicon.visible()
    if state then
      hs.dockicon.hide()
      hs.closeConsole()
      -- 清理控制台
      hs.console.clearConsole()
    else
      hs.dockicon.show()
      hs.openConsole(true)
    end
end

hs.hotkey.bind({'cmd', 'option', 'shift'}, 'c', function()
  toggleConsole()
end)

hs.hotkey.bind({'cmd', 'option', 'shift'}, 'r', function()
  hs.relaunch()
end)

initSetting()
