local connectAirPods = require 'plugins.caffWatch.connectAirPods'
local killApp = require 'plugins.caffWatch.killApp'
local setVolume = require 'plugins.caffWatch.setVolume'

local watcher = {
  connectAirPods,
  killApp,
  setVolume
}

local function findKey(eventType)
  local name
  for key, value in pairs(hs.caffeinate.watcher) do
    if value == eventType then
      name = key
      break
    end
  end
  return name
end

local function caffeinateCallback(eventType)
  local key = findKey(eventType)
  Log(key)

  for _, value in pairs(watcher) do
    local event = value[key]
    if event ~= nil then
        event()
    end
  end
end

CaffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
CaffeinateWatcher:start()
