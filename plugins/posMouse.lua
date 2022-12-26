local hyper = {'alt'}

-- 切换显示器
hs.hotkey.bind(hyper, '`', function()
  local screen = hs.mouse.getCurrentScreen()
  local nextScreen = screen:next()
  local rect = nextScreen:fullFrame()
  local center = hs.geometry.rectMidPoint(rect)

  hs.mouse.absolutePosition(center)
  hs.eventtap.leftClick(center)
end)

-- 浏览器翻译
hs.hotkey.bind(hyper, 'a', function()
  local app = hs.application.frontmostApplication()

  -- chrome 浏览器内执行
  if app ~= nil and app:bundleID() == "com.google.Chrome" then
    local win = app:focusedWindow()
    local frame = win:frame()
    -- 当前鼠标位置
    local originPoint = hs.mouse.absolutePosition()

    -- 在左侧触发右键点击
    local rightPoint = {
      x = frame.x + (win:isFullScreen() and 0 or 5),
      y = frame.h / 2
    }
    hs.eventtap.rightClick(rightPoint)

    -- 点击菜单翻译按钮位置
    local translatePoint = {
      x = rightPoint.x + 80,
      y = rightPoint.y + 255
    }
    hs.eventtap.leftClick(translatePoint)

    -- 恢复鼠标初始位置
    hs.eventtap.leftClick(originPoint)
  end
end)

