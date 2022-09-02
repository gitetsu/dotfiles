local wezterm = require "wezterm"

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

local config = {
  audible_bell = "Disabled",

  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
  font = wezterm.font_with_fallback {
    "D2Coding",
    {
      family = "Menlo",
    },
    "Apple Color Emoji",
  },
  font_size = 11.0,
  adjust_window_size_when_changing_font_size = false,

  color_scheme = "tender (base16)",
  color_schemes = {
    ["Adventure"] = {},
    ["Bright Lights Modified"] = bright_lights,
    ["Gruvbox dark, pale (base16)"] = {},
    ["MaterialOcean"] = {},
    ["lovelace"] = {},
    -- ["tender (base16)"] = {},
    ["tokyonight"] = {},
    ["Tomorrow Night"] = {},
    ["wilmersdorf"] = {},
    ["zenbones_dark"] = {},
    ["zenwritten_dark"] = {},
  },
  window_background_opacity = 0.8,

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

  leader = { key = "t", mods = "CTRL" },
  keys = {
    { key = "t", mods = "LEADER|CTRL", action = wezterm.action { SendKey = { key = "t", mods = "CTRL" } } },

    -- panes
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
    },
    { key = "-", mods = "LEADER|CTRL", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "h", mods = "LEADER|CTRL", action = wezterm.action { ActivatePaneDirection = "Left" } },
    { key = "j", mods = "LEADER|CTRL", action = wezterm.action { ActivatePaneDirection = "Down" } },
    { key = "k", mods = "LEADER|CTRL", action = wezterm.action { ActivatePaneDirection = "Up" } },
    { key = "l", mods = "LEADER|CTRL", action = wezterm.action { ActivatePaneDirection = "Right" } },

    -- tabs
    { key = "c", mods = "LEADER|CTRL", action = wezterm.action { SpawnTab = "CurrentPaneDomain" } },
    {
      key = "d",
      mods = "LEADER|CTRL",
      action = wezterm.action_callback(function(window, pane)
        local overrides = window:get_config_overrides() or {}
        overrides.enable_tab_bar = not overrides.enable_tab_bar
        window:set_config_overrides(overrides)
      end),
    },
    { key = "n", mods = "LEADER|CTRL", action = wezterm.action { ActivateTabRelative = 1 } },
    { key = "p", mods = "LEADER|CTRL", action = wezterm.action { ActivateTabRelative = -1 } },

    -- copy
    { key = "[", mods = "LEADER|CTRL", action = "ActivateCopyMode" },
  },
}

return merge_tables(config, local_config())
