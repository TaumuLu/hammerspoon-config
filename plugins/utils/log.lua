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
