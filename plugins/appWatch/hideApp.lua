local hideAction = hs.hotkey.new({'cmd'}, 'h', function ()
  local apps = hs.application.frontmostApplication()
  apps:hide()
end)

return {
  id = {
    -- 'com.microsoft.rdc.macos'
  },
  hotkeys = {
    hideAction
  }
}
