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

-- 隐藏当前 app，有些 app 没有绑定此快捷键，大部分 app 有此功能
hs.hotkey.bind({'cmd'}, 'h', function ()
  local apps = hs.application.frontmostApplication()
  local win = apps:focusedWindow()
  -- 如果当前程序为全屏展示则直接回桌面
  if win:isFullScreen() then
    local finder = hs.window.desktop():application()
    finder:activate()
    -- 激活后延时下再隐藏，否则有 50% 的几率还是会显示
    hs.timer.doAfter(0, function()
      finder:hide()
    end)
  else
    apps:hide()
  end
end)
