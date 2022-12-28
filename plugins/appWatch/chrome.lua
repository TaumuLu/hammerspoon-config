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
    y = frame.h / 2
  }
  hs.eventtap.rightClick(rightPoint)

  -- 点击菜单翻译按钮位置
  local translatePoint = {
    x = rightPoint.x + 80,
    y = rightPoint.y + (isFull and 255 or 230)
  }
  hs.eventtap.leftClick(translatePoint)

  -- 关闭地址栏翻译弹框
  hs.eventtap.leftClick(rightPoint)

  -- 恢复鼠标初始位置
  hs.mouse.absolutePosition(originPoint)
end)

return {
  id = {
    'com.google.Chrome'
  },
  enable = function()
    translateAction:enable()
  end,
  disable = function()
    translateAction:disable()
  end
}
