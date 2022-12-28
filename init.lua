-- 引入配置
require 'config'

-- 引入工具模块，全局变量的方式使用
require 'plugins.utils'

require 'plugins.autoReload'
require 'plugins.resetLaunch'
require 'plugins.hotkey'

require 'plugins.hsSetting'

require 'plugins.appWatch'
require 'plugins.caffWatch'

-- require 'plugins.istatMenus'
require 'plugins.sizeup'

-- -- 加载 Spoons
-- -- 定义默认加载的 Spoons
-- if not Hspoon_list then
--     Hspoon_list = {
--     }
-- end

-- -- 加载 Spoons
-- for _, v in pairs(Hspoon_list) do
--     hs.loadSpoon(v)
-- end

-- hs.watchable https://www.hammerspoon.org/docs/hs.watchable.html
-- hs.fnutils https://www.hammerspoon.org/docs/hs.fnutils.html
