-- local.luaからも参照するのでグローバル
function modifier()
  return {"shift", "ctrl"}
end

local function reloadConfig(files)
  local doReload = false
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

local function focusWithMouse(app)
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
hs.hotkey.bind(modifier(), "d", function() focusWithMouse("Dictionary") end)
hs.hotkey.bind(modifier(), "f", function() focusWithMouse("Finder") end)
hs.hotkey.bind(modifier(), "g", function() focusWithMouse("Google Chrome") end)
hs.hotkey.bind(modifier(), "i", function() focusWithMouse("iTerm") end)
hs.hotkey.bind(modifier(), "v", function() focusWithMouse("MacVim") end)

local function keyCode(key, modifiers)
  modifiers = modifiers or {}
  return function()
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
    hs.timer.usleep(1000)
    hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
  end
end

local function remapKey(modifiers, key, keyCode)
  return hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

local ctrlD = remapKey({'ctrl'}, 'd', keyCode('forwarddelete'))
local ctrlJ = remapKey({'ctrl'}, 'j', keyCode('return'))
local ctrlH = remapKey({'ctrl'}, 'h', keyCode('delete'))
local ctrlLeftBracket = remapKey({'ctrl'}, '[', keyCode('escape'))

local ctrlBasedHotkeys = {
  ctrlD,
  ctrlJ,
  ctrlH,
  ctrlLeftBracket,
}

hs.window.filter.new{'Terminal', 'iTerm2', 'MacVim'}
  :subscribe(hs.window.filter.windowFocused, function()
    hs.fnutils.each(ctrlBasedHotkeys, function(hotkey)
      hotkey:disable()
    end)
  end)
  :subscribe(hs.window.filter.windowUnfocused, function()
    hs.fnutils.each(ctrlBasedHotkeys, function(hotkey)
      hotkey:enable()
    end)
  end)
