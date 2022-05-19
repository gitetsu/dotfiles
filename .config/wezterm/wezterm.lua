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

local config = {
  font = wezterm.font_with_fallback {
    {
      family = "Hermit",
    },
    {
      family = "ShureTechMono Nerd Font Mono",
      -- https://github.com/wez/wezterm/issues/1736#issuecomment-1073046902
      harfbuzz_features = { "liga=0" },
    },
    "Apple Color Emoji",
  },
  font_size = 9.0,
  adjust_window_size_when_changing_font_size = false,

  color_scheme = "Ayu Mirage",
  window_background_opacity = 0.8,

  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 700,

  -- https://github.com/wez/wezterm/issues/284
  initial_rows = 100,
  initial_cols = 300,
  window_decorations = "RESIZE",
  tab_bar_at_bottom = true,

  exit_behavior = "Close",

  leader = { key = "t", mods = "CTRL" },
  keys = {
    { key = "t", mods = "LEADER|CTRL", action = wezterm.action { SendString = "t" } },
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
    },
    { key = "-", mods = "LEADER", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
    { key = "h", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Left" } },
    { key = "j", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Down" } },
    { key = "k", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Up" } },
    { key = "l", mods = "LEADER", action = wezterm.action { ActivatePaneDirection = "Right" } },
  },
}

return merge_tables(config, local_config())
