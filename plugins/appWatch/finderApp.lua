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

-- 获取 finder 当前路径
local getCurrentDir = [[
tell application "Finder"
	if exists Finder window 1 then
		set currentDir to target of Finder window 1 as alias
	else
		set currentDir to desktop as alias
	end if
end tell

do shell script "echo " & quoted form of POSIX path of currentDir
]]

local paths = {}

colseAction = hs.hotkey.new({'cmd'}, 'w', function ()
  colseAction:disable()
  local success,result,desc = hs.osascript.applescript(getCurrentDir)
  if success then
    table.insert(paths, result)
    Inspect(paths)
  end
  hs.eventtap.keyStroke({'cmd'}, 'w')
  colseAction:enable()
end)

reopenPath = hs.hotkey.new({'cmd', 'shift'}, 't', function ()
  reopenPath:disable()
  local path = table.remove(paths)
  if path ~= nil then
    -- 先打开一个新 tab
    hs.eventtap.keyStroke({'cmd'}, 't')
    reopenPath:enable()
    -- 打开文件路径
    local success = hs.osascript.applescript([[
      tell application "Finder"
        set thePath to POSIX file "]]..path..[["
        set the target of the front Finder window to folder thePath
      end tell
    ]])
  else
    hs.alert('没有关闭的历史路径')
    reopenPath:enable()
  end
end)

return {
  id = appId,
  enable = function()
    deleteAction:enable()
    cutAction:enable()
    PasteAction:enable()
    colseAction:enable()
    reopenPath:enable()
    -- switchTabLeft:enable()
    -- switchTabRight:enable()
  end,
  disable = function()
    deleteAction:disable()
    cutAction:disable()
    PasteAction:disable()
    colseAction:disable()
    reopenPath:disable()
    -- switchTabLeft:disable()
    -- switchTabRight:disable()
  end
}
