{ unstable, ... }:
{
  stylix.targets.wezterm.enable = false;

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.term = "wezterm"
      config.color_scheme = 'Rosé Pine (base16)'
      config.window_background_opacity = 0.95
      config.font_size = 15
      config.enable_wayland = true
      config.hide_tab_bar_if_only_one_tab = true
      return config
    '';
  };
}
