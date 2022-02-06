require 'plugins.utils.string'
require 'plugins.utils.log'
require 'plugins.utils.event'
require 'plugins.utils.command'

function LinkPower()
  return hs.battery.powerSource() == 'AC Power'
end

local function hasWifi(wifiName)
  local ssid = hs.wifi.currentNetwork()
  Log('wifi ssid:', ssid)
  local flag = false
  if ssid then
    for _, value in pairs(wifiName) do
      if StartWith(ssid:lower(), value:lower()) then
        flag = not flag
        break
      end
    end
  end
  return flag
end

function IsWorkEnv()
  return hasWifi(WorkWifi)
end

function IsHomeEnv()
  return hasWifi(HomeWifi)
end

function LoopWait(condition, callback, time, count)
  if time == nil then
    time = 1
  end
  -- 执行次数
  if count == nil then
    count = 10
  end

  local timer
  local num = 1
  timer = hs.timer.doEvery(time, function ()
    if num >= count then
      timer:stop()
    end
    local flag = condition()
    if flag then
      timer:stop()
      callback()
    end

    num = num + 1
  end)
end

function GetTableLen(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function IsEqual(table1, table2)
  local len1 = GetTableLen(table1)
  local len2 = GetTableLen(table2)
  if len1 ~= len2 then
    return false
  end

  for k, v in pairs(table1) do
    if v ~= table2[k] then
      return false
    end
  end
  return true
end

function GetDeviceId(id)
  if id == nil then
    local uid = hs.audiodevice.defaultOutputDevice():uid()
    local index = string.find(uid, ':')
    if index ~= nil then
      uid = string.sub(uid, 0, index - 1)
    end
    return uid
  end

  return id..':output'
end

-- 必须放在外面
local timer = nil
function Debounce(callback, time)
  if time == nil then
    time = 1
  end

  return function (...)
    local args = {...}

    if timer then
      timer:stop()
      timer = nil
    end

    timer = hs.timer.doAfter(time, function()
      callback(table.unpack(args))
    end)
  end
end
