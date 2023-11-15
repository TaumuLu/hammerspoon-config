local function bluetoothSwitch(state)
  local paramStr = '--power '
  local value = ExecBlueutilCmd(paramStr)
  if value ~= tostring(state) then
    ExecBlueutilCmd(paramStr..state)
  end
end

local function handleDevice(connect)
  local param = '--connect'
  local value = '1'
  if connect == false then
    param = '--disconnect'
    value = '0'
  end

  return function ()
    BlueutilIsConnected(function (isConnected, id)
      if isConnected ~= value then
        -- fix --disconnect add --info params
        -- https://github.com/toy/blueutil/issues/58
        ExecBlueutilCmd(param..' '..id..' --info '..id)

        -- 连接/断开后发布消息
        -- LoopWait(function ()
        --   -- 直接修改，避免下面的回调多查询一次
        --   isConnected = BlueutilIsConnected()
        --   return isConnected == value
        -- end, function ()
        --   -- 连接返回 true 未连接返回 false
        --   Event:emit(Event.keys[1], isConnected == '1')
        -- end)
      elseif value == '1' then
        -- 查找并设置为默认输入输出设备
        local device = hs.audiodevice.findDeviceByUID(GetDeviceId(string.upper(id)))
        if device ~= nil then
          device:setDefaultInputDevice()
          device:setDefaultOutputDevice()
        else
          -- 断开再重新连接
          DisconnectDevice()
          ConnectDevice()
        end
      end
    end)
  end
end

ConnectDevice = handleDevice(true)
DisconnectDevice = handleDevice(false)

local hyper = {'alt'}
hs.hotkey.bind(hyper, 'l', ConnectDevice)

local hyper = {'alt', 'shift'}
hs.hotkey.bind(hyper, 'l', DisconnectDevice)

return {
  -- screensDidLock = function ()
  --   -- hs.battery.isCharged 不可靠，会返回 nil
  --   -- 已连接电源情况下不关闭蓝牙
  --   -- if (not string.find(Execute('pmset -g batt | head -n 1'), 'AC Power'))
  --   if not LinkPower() then
  --     if not IsHomeEnv() then
  --       bluetoothSwitch(0)
  --     end
  --   end
  -- end,
  -- screensDidSleep = function ()
  --   local date = os.date('*t')
  --   local hour = date.hour
  --   local min = date.min
  --   local sec = date.sec
  --   -- 夜间关闭蓝牙连接
  --   if (
  --     hour >= 23 and min > 30 or (
  --       hour >= 0 and
  --       hour <= 7
  --     )
  --   ) then
  --     Log('夜间关闭蓝牙时间 ', hour, ':', min, ':', sec)
  --     bluetoothSwitch(0)
  --   end
  -- end,
  -- screensDidUnlock = function ()
  --   -- 打开蓝牙，并等待打开后再连接 airpods
  --   bluetoothSwitch(1)
  --   -- 直接连接如果范围内不存在设备时会导致进程卡住一段时间
  --   -- LoopWait(function ()
  --   --   return ExecBlueutilCmd('--power') == '1'
  --   -- end, function ()
  --   --   ConnectDevice()
  --   -- end)
  -- end
}
