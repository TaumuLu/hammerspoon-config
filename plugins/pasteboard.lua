PasteboardWatchr = hs.pasteboard.watcher.new(function(v)
  if v ~= nil then
    local str = Trim(v)
    if StartWith(str, '-') then
      local url = string.sub(str, 3, #str)
      local flag = IsUrl(url)

      if flag then
        hs.pasteboard.setContents(url)
      end
    end

    -- local isUrl = IsUrl(str)
    -- if isUrl then
    -- end
  end
end)

PasteboardWatchr:start()

-- Eventtap = hs.eventtap.new({
--   hs.eventtap.event.types.flagsChanged,
--   hs.eventtap.event.types.keyDown
-- }, function ()
--   hs.alert(1111)
-- end)

-- Eventtap:start()

-- <meta charset='utf-8'><a href=""></a>
