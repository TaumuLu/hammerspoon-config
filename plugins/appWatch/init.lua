local yuqueWeb = require 'plugins.appWatch.yuqueWeb'
local switchTab = require 'plugins.appWatch.switchTab'
local hideApp = require 'plugins.appWatch.hideApp'
local finder = require 'plugins.appWatch.finderApp'
local safari = require 'plugins.appWatch.safariApp'

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

local function hasValue(appIds, value)
    if type(appIds) ~= 'table' then
      return appIds == value
    end

    local flag = false
    for _, v in ipairs(appIds) do
      if v == value then
        flag = true
        break;
      end
    end
    return flag
end

local prevApp
local function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    local bundleID = appObject:bundleID()
    -- print(bundleID)
    for _, v in ipairs(watcher) do
      local appIds = v.id

      if hasValue(appIds, bundleID) then
        trigger(v, 'enable', bundleID)
      elseif hasValue(appIds, prevApp) then
        trigger(v, 'disable', bundleID)
      end
    end
    prevApp = bundleID
  end
end

AppWatcher = hs.application.watcher.new(applicationWatcher)
AppWatcher:start()
