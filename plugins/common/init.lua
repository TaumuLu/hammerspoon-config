require 'plugins.common.event'

function Trim(str)
  return string.gsub(str, '[\t\n\r]+', '')
end

function Execute(cmd)
  return Trim(hs.execute(cmd))
end

function StartWith(str, val)
  local len = #val
  return string.sub(str, 0, len) == val
end

function EndWith(str, val)
  local len = #val
  local strLen = #str
  return string.sub(str, strLen - len + 1, strLen) == val
end

function ExecBlueutilCmd(params, noExec)
  local execCmd = '/usr/local/bin/blueutil '
  local cmd = '[ -x '..execCmd..' ] && '..execCmd..(params)
  if noExec ~= nil then
    return cmd
  end
  return Execute(cmd)
end

function FindDeviceId(keyword)
  return ExecBlueutilCmd("--recent | grep '"..keyword.."' | head -n 1 | awk '{print $2}' | cut -d ',' -f 1")
end

function LinkPower()
  return hs.battery.powerSource() == 'AC Power'
end

-- 缓存设备 id 信息
local deviceIdMap = {}

function FindDeviceIdByName(name)
  local id = deviceIdMap[name]
  if id == nil then
    id = FindDeviceId(name)
    deviceIdMap[name] = id
  end
  return id
end

function BlueutilIsConnected(name, callback)
  local id = FindDeviceIdByName(name)
  local isConnected = '0'
  if string.len(id) > 0 then
    isConnected = ExecBlueutilCmd('--is-connected '..id)
    if callback ~= nil then
      callback(isConnected, id)
    end
  end
  return isConnected
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

local workWifi = {
  'bytedance',
  'Nanshan',
  'WIFI-',
  '2020',
  'WXsisyphe'
}

function IsWorkEnv()
  return hasWifi(workWifi)
end

local homeWifi = {
  'ziroom',
  'Taumu',
  'MI6',
  'pangzi'
}

function IsHomeEnv()
  return hasWifi(homeWifi)
end

function LoopWait(condition, callback, time)
  if time == nil then
    time = 1
  end
  local timer
  timer = hs.timer.doEvery(time, function ()
    local flag = condition()
    if flag then
      timer:stop()
      callback()
    end
  end)
end

function Concat(...)
  local origin = {...}
  local message = ''
  for _,v in pairs(origin) do
     message = message..tostring(v)..' '
  end
  return message
end

-- hs.console.consolePrintColor(hs.drawing.color.ansiTerminalColors.fgBlue)
function PrintStyledtext(str, color, size)
  if color == nil then
    color = 'black'
  end
  if size == nil then
    size = 12
  end
  hs.console.printStyledtext(hs.styledtext.new(str, { font = { name = 'Menlo', size = size }, color = { [color] = 1, alpha = 1 } }))
end

function Log(...)
  local args = {...}
  local str = Concat('----------log----------\n', '===', table.unpack(args))
  PrintStyledtext(str, 'blue')
end

function Inspect(tab)
  local str = Concat('----------inspect----------\n', '===', hs.inspect(tab))
  PrintStyledtext(str, 'red')
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
