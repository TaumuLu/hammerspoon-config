-- 调试代码
hs.hotkey.bind({'cmd', 'option', 'shift'}, 'h', function()
  hs.urlevent.openURL('https://www.hammerspoon.org/docs/index.html')
end)

-- 测试代码
hs.hotkey.bind({'cmd', 'option', 'shift'}, 't', function()
  hs.alert.show('test')
  -- hs.alert('Hello World from Hammerspoon')
  -- speaker = hs.speech.new()
  -- speaker:speak('Hammerspoon is online')
  -- hs.notify.new({title='Hammerspoon launch', informativeText='Boss, at your service'}):send()
  -- local app = hs.window.desktop():application()
  -- hs.tabs.enableForApp(app)
  -- Inspect(hs.window.orderedWindows())
end)

-- 快捷键锁屏，对齐 win 的快捷键
hs.hotkey.bind({'cmd'}, 'l', function()
  hs.caffeinate.lockScreen()
end)

local function hideApp()
  local app = hs.application.frontmostApplication()
  if app == nil then return end

  local win = app:focusedWindow()

  if win == nil then return end

  -- 如果当前程序为全屏展示则直接回桌面
  if win:isFullScreen() then
    local finder = hs.window.desktop():application()
    finder:activate()
    -- 激活后延时下再隐藏，否则有 50% 的几率还是会显示
    hs.timer.doAfter(0, function()
      finder:hide()
    end)
  else
    -- hs.alert(app:bundleID())
    app:hide()
  end
end

-- 隐藏当前 app，有些 app 没有绑定此快捷键，大部分 app 有此功能
HideAppHotkey = hs.hotkey.bind({'cmd'}, 'h', function ()
  local app = hs.application.frontmostApplication()
  HideAppHotkey:disable()
  hs.eventtap.keyStroke({'cmd'}, 'h')
  -- 未隐藏的再执行隐藏逻辑
  if app:isHidden() ~= true then
    hs.alert('hide app')
    hideApp()
  end

  HideAppHotkey:enable()
end)

-- hs.hotkey.bind({'cmd', 'ctrl'}, 'f', function ()
--   local apps = hs.application.frontmostApplication()
--   local win = apps:focusedWindow()
--   local isFullScreen = win:isFullScreen()

--   win:setFullScreen(not isFullScreen)
-- end)

-- 切换显示器
hs.hotkey.bind('alt', '`', function()
  local screen = hs.mouse.getCurrentScreen()
  local nextScreen = screen:next()
  local rect = nextScreen:fullFrame()
  local center = hs.geometry.rectMidPoint(rect)

  hs.mouse.absolutePosition(center)
  hs.eventtap.leftClick(center)
end)

-- 粘贴为纯文本
PasteTextHotkey = hs.hotkey.bind({'cmd', 'shift'}, 'v', function()
  hs.pasteboard.setContents(hs.pasteboard.readString())

  -- 先禁用自己
  PasteTextHotkey:disable()
  hs.eventtap.keyStroke({'cmd'}, 'v')
  -- 粘贴事件结束后再启用自己
  PasteTextHotkey:enable()
end)
