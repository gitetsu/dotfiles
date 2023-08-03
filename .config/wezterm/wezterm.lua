local wezterm = require "wezterm"
local act = wezterm.action

local local_config = function()
  local ok, _ = pcall(require, "local")
  if not ok then
    return {}
  end
  wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. "/local.lua")
  return require("local").setup()
end

local function merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      merge_tables(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

local bright_lights = wezterm.get_builtin_color_schemes()["Bright Lights"]
bright_lights.cursor_bg = "#ffc251"

local config = wezterm.config_builder()
config = {
  audible_bell = "Disabled",
  front_end = "WebGpu",

  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
  font = wezterm.font_with_fallback {
    "UDEV Gothic NF",
    "D2Coding",
    {
      family = "Menlo",
    },
    "Apple Color Emoji",
  },
  font_size = 11.0,
  adjust_window_size_when_changing_font_size = false,

  color_scheme = "Raycast_Dark",
  -- color_scheme = "Bright Lights Modified",
  color_schemes = {
    ["Adventure"] = {},
    ["Ayu Mirage (Gogh)"] = {},
    ["Bright Lights Modified"] = bright_lights,
    ["Gruvbox dark, pale (base16)"] = {},
    ["MaterialOcean"] = {},
    ["Neon (terminal.sexy)"] = {},
    ["Paraiso (base16)"] = {},
    -- ["Raycast_Dark"] = {},
    ["lovelace"] = {},
    ["tender (base16)"] = {},
    ["terafox"] = {},
    ["tokyonight"] = {},
    ["Tinacious Design (Dark)"] = {},
    ["Tomorrow Night"] = {},
    ["wilmersdorf"] = {},
    ["X::DotShare (terminal.sexy)"] = {},
    ["zenbones_dark"] = {},
    ["zenwritten_dark"] = {},
  },
  window_background_opacity = 0.75,

  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 700,

  -- https://github.com/wez/wezterm/issues/284
  initial_rows = 100,
  initial_cols = 300,
  window_decorations = "RESIZE",
  tab_bar_at_bottom = true,
  window_padding = { bottom = 0 },
  scrollback_lines = 10000,

  exit_behavior = "Close",

  enable_csi_u_key_encoding = true,

  leader = { key = "t", mods = "CTRL" },
  keys = {
    { key = "t", mods = "LEADER|CTRL", action = act { SendKey = { key = "t", mods = "CTRL" } } },

    -- panes
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } },
    },
    { key = "-", mods = "LEADER|CTRL", action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "h", mods = "LEADER|CTRL", action = act { ActivatePaneDirection = "Left" } },
    { key = "h", mods = "LEADER|SHIFT", action = act.RotatePanes "Clockwise" },
    { key = "{", mods = "LEADER", action = act { MoveTabRelative = -1 } },
    { key = "j", mods = "LEADER|CTRL", action = act { ActivatePaneDirection = "Down" } },
    { key = "k", mods = "LEADER|CTRL", action = act { ActivatePaneDirection = "Up" } },
    { key = "l", mods = "LEADER|CTRL", action = act { ActivatePaneDirection = "Right" } },
    { key = "l", mods = "LEADER|SHIFT", action = act.RotatePanes "CounterClockwise" },
    { key = "}", mods = "LEADER", action = act { MoveTabRelative = 1 } },
    { key = "g", mods = "LEADER|CTRL", action = act.TogglePaneZoomState },
    { key = ";", mods = "LEADER|CTRL", action = act.PaneSelect },

    -- tabs
    { key = "c", mods = "LEADER|CTRL", action = act { SpawnTab = "CurrentPaneDomain" } },
    {
      key = "d",
      mods = "LEADER|CTRL",
      action = wezterm.action_callback(function(window, _)
        local overrides = window:get_config_overrides() or {}
        overrides.enable_tab_bar = not overrides.enable_tab_bar
        window:set_config_overrides(overrides)
      end),
    },
    { key = "n", mods = "LEADER|CTRL", action = act { ActivateTabRelative = 1 } },
    { key = "{", mods = "LEADER", action = act { MoveTabRelative = -1 } },
    { key = "o", mods = "LEADER|CTRL", action = act.ActivateLastTab },
    { key = "p", mods = "LEADER|CTRL", action = act { ActivateTabRelative = -1 } },
    { key = "}", mods = "LEADER", action = act { MoveTabRelative = 1 } },
    { key = "1", mods = "LEADER|CTRL", action = act { ActivateTab = 0 } },
    { key = "2", mods = "LEADER|CTRL", action = act { ActivateTab = 1 } },
    { key = "3", mods = "LEADER|CTRL", action = act { ActivateTab = 2 } },
    { key = "4", mods = "LEADER|CTRL", action = act { ActivateTab = 3 } },
    { key = "5", mods = "LEADER|CTRL", action = act { ActivateTab = 4 } },
    { key = "6", mods = "LEADER|CTRL", action = act { ActivateTab = 5 } },
    { key = "7", mods = "LEADER|CTRL", action = act { ActivateTab = 6 } },
    { key = "8", mods = "LEADER|CTRL", action = act { ActivateTab = 7 } },
    { key = "9", mods = "LEADER|CTRL", action = act { ActivateTab = 8 } },

    -- copy
    { key = "[", mods = "LEADER|CTRL", action = "ActivateCopyMode" },
    { key = "w", mods = "LEADER|CTRL", action = act.QuickSelect },
  },
}

return merge_tables(config, local_config())
