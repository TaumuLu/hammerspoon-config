# hammerspoon-config
My Hammerspoon config

## Get started
1. Install Hammerspoon first.
2. `git clone https://github.com/TaumuLu/hammerspoon-config ~/.hammerspoon`
3. Reload the configutation.

## Keep update
`cd ~/.hammerspoon && git pull`

## 目录功能
- autoReload
  - 修改脚本后自动加载 hammerspoon
- stateCheck
  - 检查 hammerspoon 状态，提供快捷键显示/隐藏 dock 图标，方便调试
- resetLaunch
   - 检测 app 路径是否有改动，有改动会重置 launch 并重开 Dock 进程
- hotkey
  - 绑定全局快捷键
  - cmd+l 对齐 win 的锁屏快捷键
  - cmd+h 隐藏当前 app 快捷键
  - 多显示器快速切换定位鼠标
    - alt+` 切换鼠标到下一显示器，并且定位在其屏幕中间，且触发点击聚焦屏幕
- config
  - 配置文件，AirpodsId 及 wifi 名

### caffWatch
- 监听电脑锁屏/休眠时执行一些操作，index.lua 为入口文件
- connectAirPods
  - 屏幕锁定解锁自动开启/关闭蓝牙
  - 同时绑定快捷键连接蓝牙设备
  - alt+l 自动连接 airpods，alt+shift+l 自动断开
- killApp
  - 睡眠时杀死一些 app 防止耗电，比如 ios 模拟器就很耗电
- setVolume
  - 解锁时自动设置声音大小，会根据当前 wifi 名判断环境是否需要开启音量

### appWatch
- 监听切换 app 进入/离开时执行一些操作，index.lua 为入口文件
- finderApp
  - 绑定快捷键 cmd+d 删除操作
  - 绑定快捷键 cmd+x/cmd+v 剪切操作
- hideApp
  - 隐藏 app 快捷键绑定，暂无用
- safariApp
  - 绑定 cmd+alt+j 切换开发者工具，统一 chrome 快捷键
- switchTab
  - 绑定快捷键 cmd+alt+left/right 切换多个 tab，适用于 finder/safari
- ~~yuqueWeb~~
  - ~~为浏览器的语雀提供的脚本~~
  - ~~目的是粘贴文本时不带样式，同时保留统一 url 类型的粘贴样式~~
- autoInput
  - 自动切换输入法
- xcode
  - 绑定 xcode 快捷键为 vscode 模式
- translate
  - 添加浏览器右键翻译快捷键
- hammers
  - 添加 Hammerspoon 清空控制台日志快捷键

### sizeup
- 创建分屏快捷键，和 sizeup 一样的能力

## 参考项目
- [Hammerspoon Spoons](https://github.com/Hammerspoon/Spoons)
- [awesome-hammerspoon](https://github.com/ashfinal/awesome-hammerspoon)
- https://github.com/jasonrudolph/keyboard

### 其他项目
- https://github.com/Tao93/NetTool
- https://github.com/QaQAdrian/monitor
