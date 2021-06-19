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
local function showTips(name, title)
  local img = hs.image.imageFromPath('resources/sizeup/'..name..'.png')
  if title == nil then
    title = name
  end
  -- hs.alert.closeAll()
  -- hs.alert.showWithImage('', img:size({ w = 120, h = 1000 }), 0.5)
  destroyCanvas()
  local mainScreen = hs.screen.mainScreen()
  local mainRes = mainScreen:fullFrame()
  local text = formatUpperStr(title)
  canvas = hs.canvas.new(mainRes)
  canvas:appendElements(
    {
      type = 'rectangle',
      action = 'fill',
      fillColor = { hex = '#000', alpha = 0.5 },
      roundedRectRadii = { xRadius = 20, yRadius = 20 },
    }
  )
  if img ~= nil then
    canvas:appendElements(
      {
        type = 'image',
        image = img,
        frame = getCenterFrame({ w = 0.56, h = 0.5, y = 0.12 }),
        imageAlpha = 1
      }
    )
  else
    canvas:appendElements(
      {
        type = 'rectangle',
        action = 'stroke',
        strokeWidth = 6,
        frame = getCenterFrame({ w = 0.5, h = 0.44, y = 0.15 }),
        strokeColor = { hex = '#fff', alpha = 1 },
        roundedRectRadii = { xRadius = 20, yRadius = 20 },
      },
      {
        type = 'rectangle',
        action = 'stroke',
        strokeWidth = 5,
        frame = getCenterFrame({ w = 0.15, h = 0.15, y = 0.3 }),
        strokeColor = { hex = '#fff', alpha = 1 },
        roundedRectRadii = { xRadius = 20, yRadius = 20 },
      }
    )
  end
  canvas:appendElements(
    {
      type = 'text',
      text = text,
      textColor = { hex = '#fff' },
      strokeWidth = 0.5,
      textAlignment = 'center',
      frame = { x = '0', y = '0.7', w = '1', h = '1' }
    }
  )
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
  -- local app = win:application()
  local newrect
  local isMove = true

  -- 当前布局信息
  local curSize = win:size()
  local curTopLeft = win:topLeft()
  local curRect = { curTopLeft.x, curTopLeft.y, curSize.w, curSize.h }

  local value = posTable[pos]
  local title = pos

  if value ~= nil then
    newrect = value
  -- 居中
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
    -- 计算居中
    win:setTopLeft({ x = (frame.w - curSize.w) / 2 + frame.x, y = (frame.h - curSize.h) / 2 + frame.y })
    -- centerOnScreen 会包含 dock 高度
    -- win:centerOnScreen()
    isMove = false
  -- 恢复之前的状态
  elseif pos =='snap-back' then
    newrect = prevRect
    prevRect = curRect
  -- 移动屏幕
  elseif StartWith(pos, 'screen') then
    isMove = false
    local isSetFullScreen = GetTableLen(hs.screen.allScreens()) > 1 and win:isFullScreen()
    if isSetFullScreen then
      win:setFullScreen(false)
      win:move(posTable['full-screen'])
    end
    if pos == 'screen-up' then
      pos = 'up'
      win:moveOneScreenNorth()
    elseif pos == 'screen-down' then
      pos = 'down'
      win:moveOneScreenSouth()
    elseif pos == 'screen-left' then
      pos = 'left'
      win:moveOneScreenWest()
    elseif pos == 'screen-right' then
      pos = 'right'
      win:moveOneScreenEast()
    end
    -- 把鼠标也切换过去
    screen = win:screen()
    frame = screen:frame()
    local center = hs.geometry.rectMidPoint(frame)
    hs.mouse.setAbsolutePosition(center)
    -- 设置回全屏
    if isSetFullScreen then
      -- 延迟1秒，否则有问题
      hs.timer.doAfter(1, function()
        win:setFullScreen(true)
      end)
    end
  -- 放大缩小
  elseif StartWith(pos, 'zoom') then
    isMove = false
    local scale = curSize.w / curSize.h
    local w = frame.w * 0.1
    local h = w / scale
    -- 计算中心
    local originX = curTopLeft.x + curSize.w / 2
    local originY = curTopLeft.y + curSize.h / 2
    if pos == 'zoom-in' then
      w = curSize.w + w
      h = curSize.h + h
    elseif pos == 'zoom-out' then
      w = curSize.w - w
      h = curSize.h - h
    end
    local x = math.floor(originX - w / 2)
    local y = math.floor(originY - h / 2)
    -- 不允许超出
    if w >= frame.w then
      w = frame.w
      x = 0
    end
    if h >= frame.h then
      h = frame.h
      y = 0
    end
    -- 要先设置中心再设置宽高
    win:setTopLeft({ x, y })
    win:setSize(w, h)
  -- 移动
  elseif StartWith(pos, 'move') then
    isMove = false
    local scale = 0.1
    local x = frame.w * scale
    local y = frame.w * scale
    if pos == 'move-left' then
      x = curTopLeft.x - x
      y = curTopLeft.y
    elseif pos == 'move-right' then
      x = curTopLeft.x + x
      y = curTopLeft.y
    elseif pos == 'move-up' then
      x = curTopLeft.x
      y = curTopLeft.y - y
    elseif pos == 'move-down' then
      x = curTopLeft.x
      y = curTopLeft.y + y
    end
    local maxX = frame.w - curSize.w
    local maxY = frame.h - curSize.h
    if x < 0 then x = 0 end
    if x > maxX then x = maxX end
    if y < 0 then y = 0 end
    if y > maxY then y = maxY end
    win:setTopLeft({ x, y })
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

  showTips(pos, title)
end

-- 上下左右对半
hs.hotkey.bind({'ctrl', 'cmd'}, 'left',  hs.fnutils.partial(sizeup, 'left'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'right', hs.fnutils.partial(sizeup, 'right'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'up',    hs.fnutils.partial(sizeup, 'up'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'down',  hs.fnutils.partial(sizeup, 'down'))

-- 上下左右移动
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'left',  hs.fnutils.partial(sizeup, 'move-left'))
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'right', hs.fnutils.partial(sizeup, 'move-right'))
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'up',    hs.fnutils.partial(sizeup, 'move-up'))
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'down',  hs.fnutils.partial(sizeup, 'move-down'))

-- 上下左右切换屏幕
hs.hotkey.bind({'ctrl', 'alt'}, 'left',  hs.fnutils.partial(sizeup, 'screen-left'))
hs.hotkey.bind({'ctrl', 'alt'}, 'right', hs.fnutils.partial(sizeup, 'screen-right'))
hs.hotkey.bind({'ctrl', 'alt'}, 'up',    hs.fnutils.partial(sizeup, 'screen-up'))
hs.hotkey.bind({'ctrl', 'alt'}, 'down',  hs.fnutils.partial(sizeup, 'screen-down'))

-- 上下左右对角
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'left',  hs.fnutils.partial(sizeup, 'upper-left'))
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'right', hs.fnutils.partial(sizeup, 'lower-right'))
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'up',    hs.fnutils.partial(sizeup, 'upper-right'))
hs.hotkey.bind({'ctrl', 'cmd', 'alt'}, 'down',  hs.fnutils.partial(sizeup, 'lower-left'))

-- 居中、重置尺寸居中、全屏、切换上一状态
hs.hotkey.bind({'ctrl', 'cmd'}, 'n', hs.fnutils.partial(sizeup, 'center'))
hs.hotkey.bind({'ctrl', 'cmd', 'shift'}, 'n', hs.fnutils.partial(sizeup, 'center-resize'))
hs.hotkey.bind({'ctrl', 'cmd'}, 'm', hs.fnutils.partial(sizeup, 'full-screen'))
hs.hotkey.bind({'ctrl', 'cmd'}, '/', hs.fnutils.partial(sizeup, 'snap-back'))

-- 放大缩小
hs.hotkey.bind({'ctrl', 'cmd'}, '=', hs.fnutils.partial(sizeup, 'zoom-in'))
hs.hotkey.bind({'ctrl', 'cmd'}, '-', hs.fnutils.partial(sizeup, 'zoom-out'))
