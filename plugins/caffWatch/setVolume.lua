-- local date = os.date('*t')
-- hs.alert(os.date('%Y-%m-%d %H:%M:%S', os.time()))
-- for k,v in pairs(date) do
--   print(k,v)
-- end
-- hs.execute('osascript -e 'set volume 10'')

local volumeValue = {
  Airpods = 30,
  Input = 100,
  Speaker = 35
}

local function setVolumeOutput(value)
  if value == nil then
    value = volumeValue.Airpods
  end
  hs.execute('osascript -e "set volume output volume "'..value)
end

local function setVolumeInput(value)
  if value == nil then
    value = volumeValue.Input
  end
  hs.execute('osascript -e "set volume input volume "'..value)
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
  local date = os.date('*t')
  local hour = date.hour
  -- local min = date.min
  -- local wday = date.wday

  if not not isConnected then
    return volumeValue.Airpods
  end

  if hour >= 0
  or hour <= 6 then
    return volumeValue.Speaker
  end
  return volumeValue.Speaker + 10
end

-- 直接对比默认输出设备是否和蓝牙连接的设备是否相同
local function hasConnected()
  local deviceId = GetDeviceId()
  return string.lower(AirPodsId) == string.lower(deviceId)
end

-- 根据 wifi 名判断是否静音
local setTrigger = Debounce(function()
  local isMute = not IsHomeEnv()
  local isConnected = hasConnected()
  local volume = getVolume(isConnected)
  Log('isMute', isMute)
  Log('isConnected', isConnected)
  Log('volume', volume)

  if isMute then
    if not isConnected then
      return setVolumeMuted(true)
    end
  end
  setVolumeOutput(volume)
  setVolumeInput()
end, 0.5)

-- local timer
-- -- 监听蓝牙设备 airpods 的连接变化
-- Event:on(Event.keys[1], function (isConnected)
--   timer:stop()
--   timer = hs.timer.doAfter(2, function()
--     setTrigger()
--   end)
-- end)

-- 监听 wifi 变化
SetVolumeWifiWatch = hs.wifi.watcher.new(function ()
  local ssid = hs.wifi.currentNetwork()
  if ssid ~= nil then
    setTrigger()
  end
end):start()

-- 监听音频设备变化
hs.audiodevice.watcher.setCallback(function ()
  setTrigger()
end)
hs.audiodevice.watcher.start()

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
