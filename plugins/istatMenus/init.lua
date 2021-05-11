local obj={}

obj.__index = obj

obj.interval = 2

function obj:start()
  if obj.menubar == nil then
    obj.menubar = hs.menubar.new()
  end
  obj.icon = hs.image.imageFromPath('resources/network-menubar.png'):size({ w = 5, h = 100 })
  obj.menubar:returnToMenuBar()
  obj:rescan()
end

function obj:stop()
  obj.menubar:removeFromMenuBar()
  obj.timer:stop()
end

function obj:toggle()
  if obj.timer:running() then
    obj:stop()
  else
    obj:start()
  end
end

local function getFormatValue(value)
  local kbValue = value / 1024
  if kbValue > 1024 then
    return string.format('%8.2f MB/s', kbValue / 1024)
  else
    return string.format('%8.0f KB/s', kbValue)
  end
end

local function setTitle(inValue, outValue)
  if inValue == nil then inValue = 0 end
  if outValue == nil then outValue = 0 end

  local disp_str = getFormatValue(outValue)..'\n'..getFormatValue(inValue)
  local title = hs.styledtext.new(disp_str, { font = { size = 9 }, color = { hex = '#FFF' }, superscript = 0, baselineOffset = -5,  paragraphStyle = { alignment = 'right', maximumLineHeight = 10 } })

  obj.menubar:setIcon(obj.icon)
  obj.menubar:setTitle(title)
end

local function calcNetSpeed()
  local in_seq = hs.execute(obj.instr)
  local out_seq = hs.execute(obj.outstr)
  local in_diff = in_seq - obj.inseq
  local out_diff = out_seq - obj.outseq

  obj.inseq = in_seq
  obj.outseq = out_seq

  setTitle(in_diff, out_diff)
end

local function setMenu()
  local menuitems_table = {}
  if obj.interface then
    local interface_detail = hs.network.interfaceDetails(obj.interface)
    if interface_detail.AirPort then
      local ssid = interface_detail.AirPort.SSID
      table.insert(menuitems_table, {
        title = 'SSID: '..ssid,
        tooltip = 'Copy SSID to clipboard',
        fn = function() hs.pasteboard.setContents(ssid) end
      })
    end
    if interface_detail.IPv4 then
      local ipv4 = interface_detail.IPv4.Addresses[1]
      table.insert(menuitems_table, {
        title = 'IPv4: '..ipv4,
        tooltip = 'Copy IPv4 to clipboard',
        fn = function() hs.pasteboard.setContents(ipv4) end
      })
    end
    if interface_detail.IPv6 then
      local ipv6 = interface_detail.IPv6.Addresses[1]
      table.insert(menuitems_table, {
        title = 'IPv6: '..ipv6,
        tooltip = 'Copy IPv6 to clipboard',
        fn = function() hs.pasteboard.setContents(ipv6) end
      })
    end
    local macaddr = hs.execute('ifconfig '..obj.interface..' | grep ether | awk \'{print $2}\'')
    table.insert(menuitems_table, {
      title = 'MAC Addr: '..macaddr,
      tooltip = 'Copy MAC Address to clipboard',
      fn = function() hs.pasteboard.setContents(macaddr) end
    })
  end
  table.insert(menuitems_table, {
    title = 'Rescan Network Interfaces',
    fn = function() obj:rescan() end
  })
  obj.menubar:setMenu(menuitems_table)
end

function obj:rescan()
  obj.interface = hs.network.primaryInterfaces()
  -- obj.darkmode = hs.osascript.applescript('tell application 'System Events'\nreturn dark mode of appearance preferences\nend tell')

  if obj.interface then
    obj.instr = 'netstat -ibn | grep -e ' .. obj.interface .. ' -m 1 | awk \'{print $7}\''
    obj.outstr = 'netstat -ibn | grep -e ' .. obj.interface .. ' -m 1 | awk \'{print $10}\''

    obj.inseq = hs.execute(obj.instr)
    obj.outseq = hs.execute(obj.outstr)

    if obj.timer then
      obj.timer:stop()
      obj.timer = nil
    end
    obj.timer = hs.timer.doEvery(obj.interval, calcNetSpeed)
    calcNetSpeed()
  else
    setTitle()
  end
  setMenu()
end

obj:start()

hs.wifi.watcher.new(function ()
  obj:rescan()
end):start()