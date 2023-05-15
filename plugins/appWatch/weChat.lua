local id = 'com.tencent.xinWeChat.WeChatAppEx'

return {
  id = id,
  enable = function(_, prevId)
    -- 只有从微信打开的窗口才自动跳转去浏览器
    -- if prevId ~= string.lower('com.tencent.xinWeChat') then
    --   return
    -- end
    local app = hs.application.frontmostApplication()
    local win = app:focusedWindow()

    -- 微信小程序不做处理
    if app:name() ~= win:title() then
        return
    end

    -- 延迟 0.3s 等窗口完全打开 ui 可见后再执行
    hs.timer.doAfter(0.3, function()
      local frame = win:frame()
      local offset = 20
      local rightFrame = { x = frame.x + frame.w - offset, y = frame.y + offset }
      hs.eventtap.leftClick(rightFrame)
      hs.eventtap.leftClick({ x = rightFrame.x, y = rightFrame.y + 120 })
    end)
  end,
  disable = function()
    -- 切换其他应用后自动关闭窗口
    local apps = hs.application.applicationsForBundleID(id)
    for _, app in pairs(apps) do
      local win = app:focusedWindow()
      -- 微信小程序不做处理
      if app:name() ~= win:title() then
        return
      end

      win:close()
    end
  end,
}

-- return {
--   id = id,
--   enable = function()
--     local app = hs.application.frontmostApplication()
--     local win = app:focusedWindow()

--     -- 微信小程序不做处理
--     if app:name() ~= win:title() then
--         return
--     end

--     local apps = hs.application.applicationsForBundleID('com.tencent.xinWeChat')
--     for _, item in pairs(apps) do
--       item:mainWindow():focus()
--     end

--     -- 模拟按下 cmd 点击事件
--     -- 参考 https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/eventtap/eventtap.lua#L147
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.absolutePosition(),  { "cmd" }):post()
--     hs.timer.usleep(200000)
--     hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.absolutePosition(),  { "cmd" }):post()
--   end,
--   disable = function()
--     -- 切换其他应用后自动关闭窗口
--     local apps = hs.application.applicationsForBundleID(id)
--     for _, app in pairs(apps) do
--       app:focusedWindow():close()
--     end
--   end,
-- }

