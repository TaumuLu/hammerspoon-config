local fullScreen = hs.hotkey.new({'cmd', 'ctrl'}, 'f', function ()
  local apps = hs.application.frontmostApplication()
  local win = apps:focusedWindow()
  local isFullScreen = win:isFullScreen()

  win:setFullScreen(not isFullScreen)
end)

return {
  id = {
    'com.google.Chrome'
  },
  enable = function()
    fullScreen:enable()
  end,
  disable = function()
    fullScreen:disable()
  end
}
