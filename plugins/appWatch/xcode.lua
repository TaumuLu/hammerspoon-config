local showPreviousTab = hs.hotkey.new({'cmd', 'alt'}, 'left', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Show Previous Tab')
end)

local showNextTab = hs.hotkey.new({'cmd', 'alt'}, 'right', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Show Next Tab')
end)

local selectColumnUp = hs.hotkey.new({'alt'}, 'up', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Move Line Up')
end)

local selectColumnDown = hs.hotkey.new({'alt'}, 'down', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Move Line Down')
end)

local duplicate = hs.hotkey.new({'alt', 'shift'}, 'down', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Duplicate')
end)

local selectNextOccurrence = hs.hotkey.new({'cmd'}, 'd', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Select Next Occurrence')
end)

local cut = hs.hotkey.new({'cmd'}, 'x', function()
  local app = hs.application.frontmostApplication()
  local cutMenuItem = app:findMenuItem('Cut')
  if cutMenuItem.enabled then
    app:selectMenuItem('Cut')
  else
    hs.eventtap.keyStroke({'ctrl', 'alt', 'shift'}, 'd')
  end
end)

return {
  id = {
    'com.apple.dt.Xcode'
  },
  hotkeys = {
    showPreviousTab,
    showNextTab,
    selectColumnUp,
    selectColumnDown,
    duplicate,
    selectNextOccurrence,
    cut,
  }
}
