-- local.luaからも参照するのでグローバル
function modifier()
  return { "shift", "ctrl" }
end

function focusWithMouse(app)
  local beforeScreen = hs.window.focusedWindow():screen()
  if hs.application.launchOrFocus(app) then
    local afterScreen = hs.window.focusedWindow():screen()
    if #hs.screen.allScreens() > 1 and beforeScreen ~= afterScreen then
      local geo = afterScreen:frame()
      hs.mouse.setRelativePosition({ x = geo.w / 2, y = geo.h / 2 }, afterScreen)
    end
  end
end

hs.loadSpoon "ReloadConfiguration"
spoon.ReloadConfiguration:start()

if hs.fs.displayName "local.lua" then
  require "local"
end

hs.hotkey.bind(modifier(), "a", function()
  focusWithMouse "Activity Monitor"
end)
hs.hotkey.bind(modifier(), "b", function()
  focusWithMouse "Vivaldi"
end)
hs.hotkey.bind(modifier(), "d", function()
  focusWithMouse "Dictionary"
end)
hs.hotkey.bind(modifier(), "f", function()
  focusWithMouse "Finder"
end)
hs.hotkey.bind(modifier(), "g", function()
  focusWithMouse "Google Chrome"
end)
hs.hotkey.bind(modifier(), "i", function()
  focusWithMouse "WezTerm"
end)
hs.hotkey.bind(modifier(), "k", function()
  focusWithMouse "Kindle"
end)
hs.hotkey.bind(modifier(), "s", function()
  focusWithMouse "System Preferences"
end)
hs.hotkey.bind(modifier(), "v", function()
  focusWithMouse "MacVim"
end)