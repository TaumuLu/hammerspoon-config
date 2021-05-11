-- hs.hotkey.bind({'ctrl', 'cmd'}, '.', function()
--     hs.alert.show('App path:        '
--     ..hs.window.focusedWindow():application():path()
--     ..'\n'
--     ..'App name:      '
--     ..hs.window.focusedWindow():application():name()
--     ..'\n'
--     ..'IM source id:  '
--     ..hs.keycodes.currentSourceID())
-- end)

-- function trim(text)
--     if text ~= nil then
--         return string.gsub(text, '[%s]+', '')
--     end
--     return text
-- end

-- k = hs.hotkey.new({'cmd'}, 'v', function()
--     -- hs.eventtap.event.newKeyEvent({'cmd','option','shift'}, 'v', true):post()
--     hs.eventtap.keyStrokes(hs.pasteboard.getContents())
--     -- hs.eventtap.keyStroke({'cmd','option','shift'}, 'v')
-- end)

-- local switchTabLeft = hs.hotkey.new({'alt', 'cmd'}, 'left', function()
--   hs.eventtap.keyStroke({'cmd','shift'}, '[')
-- end)
-- local switchTabRight = hs.hotkey.new({'alt', 'cmd'}, 'right', function()
--   hs.eventtap.keyStroke({'cmd','shift'}, ']')
-- end)

-- yuquePaste script

local htmlUti = 'public.html'
local textUti = 'public.utf8-plain-text'

local function setPlainText(value)
  local text = value or hs.pasteboard.getContents()
  if text ~= nil then
    local content = string.gsub(text, '%s*[\n]+%s*', '\n')
    hs.pasteboard.setContents(content)
  end
end

local function setUrlHtml(url, text)
  local table = {}
  local html = string.format([[
  <meta charset='utf-8' />
  <a
    href='%s'
    >%s</a
  >
  ]], url, text)
  table[htmlUti] = html
  table[textUti] = text
  hs.pasteboard.writeAllData(table)
end

local isSkip = false
local hyper = {'cmd', 'option', 'shift'}
hs.hotkey.bind(hyper, 'p', function()
  hs.alert('skip next paste')
  isSkip = true
end)

local prevValue

local function yuquePaste()
  if isSkip == true then
    prevValue = nil
    isSkip = false
    return
  end

  local value = hs.pasteboard.getContents()
  if prevValue == value then
    return
  end

  prevValue = value
  -- hs.alert(prevValue)
  -- hs.alert(value)
  -- hs.alert(bundleID)
  -- k:enable()
  local contentTypes = hs.pasteboard.contentTypes()
  local utiType = contentTypes[1]
  if utiType == textUti then
    setPlainText(value)
  elseif utiType == htmlUti then
    local data = hs.pasteboard.readAllData()
    local html = data[htmlUti]
    local iter = string.gmatch(html, '\'(https?://[^\']*)\'')

    local url
    for w, v in iter do
      if url ~= nil then
        url = nil
        break
      end
      url = w
    end
    local urlText = string.gsub(html, '<[^<>]*>', '')
    if url ~= nil and urlText == value then
      setUrlHtml(url, value)
    else
      setPlainText(value)
    end
  else
  end
  -- for index, uti in ipairs(contentTypes) do
  --   if uti == 'public.utf8-plain-text' then
  --     break
  --   end
  -- end
  -- print(hs.inspect.inspect(utiType))
  -- k:disable()
end

-- watch app script
return {
  id = {
    -- 'com.apple.Safari',
    'com.google.Chrome.canary'
  },
  enable = function()
    -- yuquePaste()
  end,
}
