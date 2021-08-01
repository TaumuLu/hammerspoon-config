local yuqueWeb = require 'plugins.appWatch.yuqueWeb'
local switchTab = require 'plugins.appWatch.switchTab'
-- local hideApp = require 'plugins.appWatch.hideApp'
local finder = require 'plugins.appWatch.finderApp'
local safari = require 'plugins.appWatch.safariApp'
local hideApp = require 'plugins.appWatch.closeWin'

local watcher = {
  yuqueWeb,
  switchTab,
  hideApp,
  finder,
  safari
}

local function trigger(object, name, ...)
  -- local args={...}
  -- print(hs.inspect(args))
  if object[name] ~= nil then
    object[name](...)
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
  if (eventType == hs.application.watcher.activated) then
    local bundleID = appObject:bundleID()
    -- print(bundleID)
    for id, list in pairs(appMap) do
      -- 启用当前激活 app 脚本
      if id == bundleID then
        for _, item in ipairs(list) do
          trigger(item, 'enable', bundleID)
        end
      -- 禁用上一个激活 app 的脚本
      elseif id == prevApp then
        for _, item in ipairs(list) do
          trigger(item, 'disable', bundleID)
        end
      end
    end
    -- for _, v in ipairs(watcher) do
    --   local appIds = v.id

    --   if hasValue(appIds, bundleID) then
    --     trigger(v, 'enable', bundleID)
    --   elseif hasValue(appIds, prevApp) then
    --     trigger(v, 'disable', bundleID)
    --   end
    -- end
    prevApp = bundleID
  end
end

AppWatcher = hs.application.watcher.new(applicationWatcher)
AppWatcher:start()
