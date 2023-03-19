local edgeId = 'com.microsoft.edgemac'

-- 浏览器翻译
local translateAction = hs.hotkey.new({'alt'}, 'a', function()
  local app = hs.application.frontmostApplication()

  local win = app:focusedWindow()
  local frame = win:frame()
  local isFull = win:isFullScreen()
  -- 当前鼠标位置
  local originPoint = hs.mouse.absolutePosition()

  -- 在左侧触发右键点击
  local rightPoint = {
    x = frame.x + (isFull and 0 or 5),
    y = frame.y + frame.h / 2
  }
  hs.eventtap.rightClick(rightPoint)

  local bundleId = app:bundleID()
  local clickY = bundleId == edgeId and 70 or (isFull and 255 or 230)

  -- 点击菜单翻译按钮位置
  local translatePoint = {
    x = rightPoint.x + 80,
    y = rightPoint.y + clickY
  }
  hs.eventtap.leftClick(translatePoint)

  -- 关闭地址栏翻译弹框
  hs.eventtap.leftClick({
    x = frame.x + frame.w - 5,
    y = frame.y + 5
  })

  -- 恢复鼠标初始位置
  hs.mouse.absolutePosition(originPoint)
end)

return {
  id = {
    'com.google.Chrome',
    edgeId
  },
  hotkeys = {
    translateAction
  },
}
