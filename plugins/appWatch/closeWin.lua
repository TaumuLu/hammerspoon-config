local closeAction = hs.hotkey.new({'cmd'}, 'w', function ()
  local apps = hs.application.frontmostApplication()
  local win = apps:focusedWindow()
  win:close()
end)

return {
  id = {
    'com.thewanderingcoel.trojan-qt5'
  },
  hotkeys = {
    closeAction
  }
}
