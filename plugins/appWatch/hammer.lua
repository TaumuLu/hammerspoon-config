-- 清理控制台
local clearConsole = hs.hotkey.new({'cmd'}, 'k', function()
  hs.console.clearConsole()
end)

return {
  id = {
    'org.hammerspoon.Hammerspoon'
  },
  hotkeys = {
    clearConsole
  }
}
