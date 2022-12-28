local appId = 'com.apple.Safari'

local switchTabLeft = hs.hotkey.new({'cmd', 'alt'}, 'j', function()
  hs.eventtap.keyStroke({'cmd', 'alt'}, 'i')
end)

return {
  id = appId,
  hotkeys = {
    switchTabLeft
  }
}
