local function getCenterFrame(rect)
  local w = rect.w
  local h = rect.h
  local x = rect.x
  local y = rect.y
  if x == nil then
    x = tostring((1 - w) / 2)
  end
  if y == nil then
    y = tostring((1 - h) / 2)
  end
  return { x = tostring(x), y = tostring(y), w = tostring(w), h = tostring(h) }
end

-- 格式化首字母大写
local function formatUpperStr(str)
  return string.gsub(str, '-', ' '):gsub('(%l)(%w*)', function(a,b) return string.upper(a)..b end)
end

local canvas
local timer

-- 销毁 canvas 和 timer
local function destroyCanvas()
  if canvas ~= nil then
    canvas:delete()
    canvas = nil
  end
  if timer ~= nil then
    timer:stop()
    timer = nil
  end
end

-- 自定义提示
local function showTips(name)
  local img = hs.image.imageFromPath('resources/sizeup/'..name..'.png')
  -- hs.alert.closeAll()
  -- hs.alert.showWithImage('', img:size({ w = 120, h = 1000 }), 0.5)
  destroyCanvas()
  local mainScreen = hs.screen.mainScreen()
  local mainRes = mainScreen:fullFrame()
  local text = formatUpperStr(name)
  canvas = hs.canvas.new(mainRes)
  canvas:appendElements(
    {
      type = 'rectangle',
      action = 'fill',
      fillColor = { hex = '#000', alpha = 0.5 },
      roundedRectRadii = { xRadius = 20, yRadius = 20 },
    }, {
      type = 'image',
      image = img,
      frame = getCenterFrame({ w = 0.56, h = 0.5, y = 0.12 }),
      imageAlpha = 1
    }, {
      type = 'text',
      text = text,
      textColor = { hex = '#fff' },
      strokeWidth = 0.5,
      textAlignment = 'center',
      frame = { x = '0', y = '0.7', w = '1', h = '1' }
    })
  local w = 210
  local h = 210
  canvas:frame({
      x = (mainRes.w - w) / 2 + mainRes.x,
      y = (mainRes.h - h) / 2 - 26 + mainRes.y,
      w = w,
      h = h
  })
  canvas:show(0.1)
  timer = hs.timer.doAfter(1, destroyCanvas)
end

local prevRect = {}

hs.window.animationDuration = 0

local posTable = {
  left = hs.layout.left50,
  right = hs.layout.right50,
  up = { 0, 0, 1, 0.5 },
  down = { 0, 0.5, 1, 0.5 },
  ['full-screen'] = hs.layout.maximized,
  ['upper-left'] = { 0, 0, 0.5, 0.5 },
  ['upper-right'] = { 0.5, 0, 0.5, 0.5 },
  ['lower-left'] = { 0, 0.5, 0.5, 0.5 },
  ['lower-right'] = { 0.5, 0.5, 0.5, 0.5 },
}

local function sizeup(pos)
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local frame = screen:frame()
  local newrect
  local isMove = true

  -- 当前布局信息
  local curSize = win:size()
  local curTopLeft = win:topLeft()
  local curRect = { curTopLeft.x, curTopLeft.y, curSize.w, curSize.h }

  local value = posTable[pos]

  if value ~= nil then
    newrect = value
  elseif pos == 'center' or pos == 'center-resize' then
    if pos == 'center-resize' then
      local w = 0.5
      local h = 0.5
      -- newrect = { (1 - w) / 2, (1 - h) / 2, w, h }
      win:setSize(frame.w * w, frame.h * h)
    end
    -- 设置回图标
    pos = 'center'
    curSize = win:size()
    -- 标题高度 24
    local titleHeight = 24
    -- 计算居中
    win:setTopLeft({ x = (frame.w - curSize.w) / 2 + frame.x, y = titleHeight + (frame.h - curSize.h) / 2 + frame.y })
    -- centerOnScreen 会包含 dock 高度
    -- win:centerOnScreen()
    isMove = false
  elseif pos =='snap-back' then
    newrect = prevRect
    prevRect = curRect
  end

  if isMove then
    win:move(newrect)
  end

  -- 更新后的布局信息
  local nextSize = win:size()
  local nextTopLeft = win:topLeft()
  local nextRect = { nextTopLeft.x, nextTopLeft.y, nextSize.w, nextSize.h }

  -- 如果布局没变化则不更新上一次的布局信息
  local isEqual = IsEqual(curRect, nextRect);
  if pos ~= 'snap-back' and not isEqual then
    prevRect = curRect
  end

  showTips(pos)
end

-- 上下左右对半
hs.hotkey.bind({'ctrl', 'cmd'}, 'left',  hs.fnutils.partial(sizeup, 'left'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'right', hs.fnutils.partial(sizeup, 'right'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'up',    hs.fnutils.partial(sizeup, 'up'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'down',  hs.fnutils.partial(sizeup, 'down'))

-- 上下左右微调
-- hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'left',  hs.fnutils.partial(sizeup, 'upper-left'))
-- hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'right', hs.fnutils.partial(sizeup, 'lower-right'))
-- hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'up',    hs.fnutils.partial(sizeup, 'upper-right'))
-- hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'down',  hs.fnutils.partial(sizeup, 'lower-left'))

-- 上下左右对角
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'left',  hs.fnutils.partial(sizeup, 'upper-left'))
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'right', hs.fnutils.partial(sizeup, 'lower-right'))
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'up',    hs.fnutils.partial(sizeup, 'upper-right'))
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'down',  hs.fnutils.partial(sizeup, 'lower-left'))

-- 居中、重置尺寸居中、全屏、切换上一状态
hs.hotkey.bind({'ctrl', 'cmd'}, 'N', hs.fnutils.partial(sizeup, 'center'))
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'N', hs.fnutils.partial(sizeup, 'center-resize'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'M', hs.fnutils.partial(sizeup, 'full-screen'))
hs.hotkey.bind({'ctrl', 'cmd'}, '/', hs.fnutils.partial(sizeup, 'snap-back'))
