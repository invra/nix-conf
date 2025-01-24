local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.term = "wezterm"
config.font = wezterm.font_with_fallback({ "JetBrains Mono Nerd Font" })
config.window_background_opacity = 0.95
config.font_size = 15
config.enable_wayland = true

config.colors = {
  foreground = 'silver',
  background = '#191724'
}

config.keys = {
  {
    key = "F",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({
      args = { "lf" },
    }),
  },
}
config.hide_tab_bar_if_only_one_tab = true
return config
