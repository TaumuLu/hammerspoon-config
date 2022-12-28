-- 清理控制台
local clearConsole = hs.hotkey.new({'cmd'}, 'k', function()
  hs.console.clearConsole()
end)

return {
  id = {
    'org.hammerspoon.Hammerspoon'
  },
  enable = function()
    clearConsole:enable()
  end,
  disable = function()
    clearConsole:disable()
  end
}
