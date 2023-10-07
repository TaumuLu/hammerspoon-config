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

local fold = hs.hotkey.new({'cmd', 'alt'}, '[', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Fold')
end)

local unfold = hs.hotkey.new({'cmd', 'alt'}, ']', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Unfold')
end)

local unfoldAll = hs.hotkey.new({'alt', 'shift'}, 'k', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Unfold All')
end)

local foldAll = hs.hotkey.new({'alt'}, 'k', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem('Fold Methods & Functions')
  app:selectMenuItem('Fold Comment Blocks')
end)

-- brew install --cask swiftformat-for-xcode
local formatOnSave = hs.hotkey.new({'cmd'}, 's', function()
  local app = hs.application.frontmostApplication()
  app:selectMenuItem({'Editor', 'SwiftFormat', 'Format File'})
  app:selectMenuItem('Save')
  hs.eventtap.keyStroke({'cmd', 'shift'}, 'j')
end)

local showDebugArea = hs.hotkey.new({'cmd'}, 'j', function()
  hs.eventtap.keyStroke({'cmd', 'shift'}, 'y')
end)

local openQuickly = hs.hotkey.new({'cmd'}, 'p', function()
  hs.eventtap.keyStroke({'cmd', 'shift'}, 'o')
end)

local showRelatedItems = hs.hotkey.new({'cmd', 'shift'}, 't', function()
  hs.eventtap.keyStroke({'ctrl'}, '1')
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
    fold,
    unfold,
    unfoldAll,
    foldAll,
    formatOnSave,
    showDebugArea,
    openQuickly,
    showRelatedItems
  }
}
