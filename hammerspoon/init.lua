function modifier()
  return {"shift", "ctrl"}
end

function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
    hs.notify.new({title="Hammerspoon", informativeText="Config reloaded"}):send()
  end
end

function focusWithMouse(app)
  local beforeScreen = hs.window.focusedWindow():screen()
  if hs.application.launchOrFocus(app) then
    local afterScreen = hs.window.focusedWindow():screen()
    if #hs.screen.allScreens() > 1 and beforeScreen ~= afterScreen then
      local geo = afterScreen:frame()
      hs.mouse.setRelativePosition({x=geo.w / 2, y=geo.h / 2}, afterScreen)
    end
  end
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

require ("local")

hs.hotkey.bind(modifier(), "a", function() focusWithMouse("Activity Monitor") end)
hs.hotkey.bind(modifier(), "b", function() focusWithMouse("Firefox") end)
hs.hotkey.bind(modifier(), "f", function() focusWithMouse("Finder") end)
hs.hotkey.bind(modifier(), "g", function() focusWithMouse("Google Chrome") end)
hs.hotkey.bind(modifier(), "i", function() focusWithMouse("iTerm") end)
hs.hotkey.bind(modifier(), "s", function() focusWithMouse("Skype") end)
hs.hotkey.bind(modifier(), "v", function() focusWithMouse("MacVim") end)
