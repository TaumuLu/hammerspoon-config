local hideAction = hs.hotkey.new({'cmd'}, 'h', function ()
  local apps = hs.application.frontmostApplication()
  apps:hide()
end)

return {
  id = {
    -- 'com.microsoft.rdc.macos'
  },
  enable = function()
    hideAction:enable()
    -- switchTabLeft:enable()
    -- switchTabRight:enable()
  end,
  disable = function()
    hideAction:disable()
    -- switchTabLeft:disable()
    -- switchTabRight:disable()
  end
}