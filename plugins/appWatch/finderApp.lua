local appId = 'com.apple.finder'

-- local keyList = {
--   hs.keycodes.map.shift,
--   hs.keycodes.map.ctrl,
--   hs.keycodes.map.tab
-- }

-- function postKeyEvent(...)
--   local args={...}
--   return function()
--     for i=1, #keyList do
--       local key = keyList[i]
--       local isdown = args[i]
--       if isdown == nil then
--         isdown = true
--       end
--       hs.eventtap.event.newKeyEvent(key, isdown):post(appId)
--     end
--   end
-- end

-- local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', postKeyEvent(true))
-- local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', postKeyEvent(false))

-- local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', function()
--   hs.eventtap.keyStroke({'cmd','shift'}, '[')
-- end)
-- local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', function()
--   hs.eventtap.keyStroke({'cmd','shift'}, ']')
-- end)

-- print(hs.inspect.inspect(hs.keycodes.map))

local deleteAction = hs.hotkey.new({'cmd'}, 'd', function ()
  hs.eventtap.keyStroke({'cmd'}, 'delete')
end)

-- command + x -> command + v
local isCut = false
local cutAction = hs.hotkey.new({'cmd'}, 'x', function ()
  isCut = true
  hs.alert('已剪切文件')
  hs.eventtap.keyStroke({'cmd'}, 'c')
end)

-- 这里必须设置为全局的函数，否则函数内无法引用到
 PasteAction = hs.hotkey.new({'cmd'}, 'v', function ()
  local modifiers = {'cmd'}
  if isCut == true then
    table.insert(modifiers, 'option')
    isCut = false
  end
  -- 先禁用，触发相同快捷键后再重启用
  PasteAction:disable()
  hs.eventtap.keyStroke(modifiers, 'v')
  PasteAction:enable()
end)

return {
  id = appId,
  enable = function()
    deleteAction:enable()
    cutAction:enable()
    PasteAction:enable()
    -- switchTabLeft:enable()
    -- switchTabRight:enable()
  end,
  disable = function()
    deleteAction:disable()
    cutAction:disable()
    PasteAction:disable()
    -- switchTabLeft:disable()
    -- switchTabRight:disable()
  end
}