local function killApp(appId)
  local apps = hs.application.applicationsForBundleID(appId)
  for _, app in ipairs(apps) do
    app:kill()
    if app:isRunning() then
      app:kill9()
    end
  end
  print('kill '..appId)
end

return {
  screensDidSleep = function ()
    if not LinkPower() then
      killApp('com.apple.iphonesimulator')
    end
  end
}
