local yuqueWeb = require 'plugins.appWatch.yuqueWeb'
local switchTab = require 'plugins.appWatch.switchTab'
-- local hideApp = require 'plugins.appWatch.hideApp'
local finder = require 'plugins.appWatch.finder'
local safari = require 'plugins.appWatch.safari'
local hideApp = require 'plugins.appWatch.closeWin'
local fullScreen = require 'plugins.appWatch.fullScreen'
local Translate = require 'plugins.appWatch.Translate'
local xcode = require 'plugins.appWatch.xcode'
local hammer = require 'plugins.appWatch.hammer'
local weChat = require 'plugins.appWatch.weChat'
-- local autoInput = require 'plugins.appWatch.autoInput'
-- local alfredCursorFix = require 'plugins.appWatch.alfredCursorFix'


local watcher = {
  yuqueWeb,
  switchTab,
  hideApp,
  finder,
  safari,
  fullScreen,
  Translate,
  xcode,
  hammer,
  weChat
}

local function trigger(object, name, ...)
  -- local args={...}
  -- print(hs.inspect(args))
  if object[name] ~= nil then
    object[name](...)
  end
end

local function hotkeyExec(hotkeys, flag)
  if hotkeys ~= nil then
    for _, item in ipairs(hotkeys) do
      if flag then
        item:enable()
      else
        item:disable()
      end
    end
  end

end

-- local function hasValue(appIds, value)
--     if type(appIds) ~= 'table' then
--       return appIds == value
--     end

--     local flag = false
--     for _, v in ipairs(appIds) do
--       if v == value then
--         flag = true
--         break;
--       end
--     end
--     return flag
-- end

local function getAppMap(watcher)
  local map = {}
  for _, v in ipairs(watcher) do
    local ids = v.id
    if type(ids) ~= 'table' then
      ids = { ids }
    end
    for _, id in ipairs(ids) do
      if map[id] == nil then
        map[id] = {}
      end
      table.insert(map[id], v)
    end
  end
  return map
end

local appMap = getAppMap(watcher)

local prevApp
local function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated and appObject ~= nil) then
    local bundleID = appObject:bundleID()
    local lBundleID = string.lower(bundleID)
    -- print(bundleID)
    if bundleID ~= 'org.hammerspoon.Hammerspoon' then
      Log('bundleID ', bundleID)
    end

    -- autoInput(bundleID)

    for id, list in pairs(appMap) do
      local lId = string.lower(id)
      -- 启用当前激活 app 脚本
      if lId == lBundleID then
        for _, item in ipairs(list) do
          trigger(item, 'enable', lBundleID, prevApp)
          hotkeyExec(item.hotkeys, true)
        end
      -- 禁用上一个激活 app 的脚本
      elseif lId == prevApp then
        for _, item in ipairs(list) do
          trigger(item, 'disable', lBundleID, prevApp)
          hotkeyExec(item.hotkeys, false)
        end
      end
    end
    -- for _, v in ipairs(watcher) do
    --   local appIds = v.id

    --   if hasValue(appIds, lBundleID) then
    --     trigger(v, 'enable', lBundleID)
    --   elseif hasValue(appIds, prevApp) then
    --     trigger(v, 'disable', lBundleID)
    --   end
    -- end
    prevApp = lBundleID
  end
end

AppWatcher = hs.application.watcher.new(applicationWatcher)
AppWatcher:start()

-- 初始立即执行
local app = hs.application.frontmostApplication()
applicationWatcher(app:name(), hs.application.watcher.activated, app)
