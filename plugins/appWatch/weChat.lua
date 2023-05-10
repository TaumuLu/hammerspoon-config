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

    -- 延迟 0.5s 等窗口完全打开 ui 可见后再执行
    hs.timer.doAfter(0.5, function()
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
      app:focusedWindow():close()
    end
  end,
}

