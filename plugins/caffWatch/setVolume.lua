-- local date = os.date('*t')
-- hs.alert(os.date('%Y-%m-%d %H:%M:%S', os.time()))
-- for k,v in pairs(date) do
--   print(k,v)
-- end
-- hs.execute('osascript -e 'set volume 10'')

local function setVolumeOutput(value)
  hs.execute('osascript -e "set volume output volume "'..value)
end

local function setVolumeMuted(value)
  local muted = 1
  if not value then
    muted = 0
  end
  hs.execute('osascript -e "set volume output muted "'..muted)
end

local function getVolume(isConnected, volume)
  if volume ~= nil then
    return volume
  end
  if not not isConnected then
    return 50
  end
  return 30
end

local function hasConnected()
  local id = FindDeviceId('connected ')
  if string.len(id) == 0 then
    return false
  end

  -- 对比默认输出设备是否和蓝牙连接的设备相同
  local uid = hs.audiodevice.defaultOutputDevice():uid()
  local index = string.find(uid, ':')
  if index ~= nil then
    uid = string.sub(uid, 0, index - 1)
  end

  return id == uid
end

local function setVolume(isMute, volume)
  local isConnected = hasConnected()
  volume = getVolume(isConnected, volume)
  Log('isMute', isMute)
  Log('isConnected', isConnected)
  Log('volume', volume)

  if isMute then
    if not isConnected then
      return setVolumeMuted(true)
    end
  end
  return setVolumeOutput(volume)
end

-- 根据时间判断是否静音
local function timeTrigger()
  local date = os.date('*t')
  local hour = date.hour
  local min = date.min
  local wday = date.wday
  local isMute = false

  if (
    wday > 1 and
    wday < 7 and
    hour >= 9 and
    hour < 19
  ) then
    isMute = true
  end

  setVolume(isMute)
end

-- 根据 wifi 名判断是否静音
local function setTrigger()
  local isWorkEnv = IsWorkEnv()
  setVolume(isWorkEnv)
end

-- 监听蓝牙设备 airpods 的连接变化
Event:on(Event.keys[1], function (isConnected)
  hs.timer.doAfter(2, function()
    setTrigger()
  end)
end)

-- 默认加载时执行一次
setTrigger()

return {
  screensDidWake = function ()
    setTrigger()
  end,
  screensDidUnlock = function ()
    setTrigger()
  end
}
