-- local function Sougou()
--   hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
-- end

local function Chinese()
  hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
end

local function English()
  hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- hs.keycodes.inputSourceChanged(function (test)
--   hs.alert(hs.keycodes.currentSourceID())
-- end)

local appMap = {
  english = {
    'com.googlecode.iterm2',
    'com.microsoft.VSCode',
    'com.microsoft.VSCodeInsiders',
    'com.sublimetext.4',
    'com.apple.dt.Xcode'
  },
  chinese = {
    'com.tencent.xinWeChat',
    'com.tencent.xinWeChat.MiniProgram',
    'com.tencent.qq',
    'com.electron.lark',
    'com.apple.Notes',
    'com.lencx.chatgpt',
    'com.google.Chrome',
    'com.microsoft.edgemac',
  }
}

local switchInput = function (boundId)
  for key, value in pairs(appMap) do
    for _, id in ipairs(value) do
      if id == boundId then
        if key == 'english' then
          English()
        else
          Chinese()
        end
      end
    end
  end
end

return switchInput
