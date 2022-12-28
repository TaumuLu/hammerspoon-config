local finder = require 'plugins.appWatch.finder'
local safari = require 'plugins.appWatch.safari'

local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', function()
  hs.eventtap.keyStroke({'cmd','shift'}, '[')
end)
local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', function()
  hs.eventtap.keyStroke({'cmd','shift'}, ']')
end)

return {
  id = {
    safari.id,
    finder.id
  },
  hotkeys = {
    switchTabLeft,
    switchTabRight
  }
}
