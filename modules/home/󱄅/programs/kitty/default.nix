{
  unstable,
  ...
}:
let
  pkgs = unstable;
in
{
  stylix.targets.kitty.enable = false;

  programs.kitty = {
    package = pkgs.kitty;
    enable = true;

    settings = {
      font_size = 18;
      disable_ligatures = "never";
      cursor_shape = "beam";
      cursor_shape_unfocused = "hollow";
      cursor_trail = 1;
      scrollback_lines = 100000;
      detect_urls = "yes";
      underline_hyperlinks = "hover";
      copy_on_select = "no";
      enable_audio_bell = "no";
      remember_window_size = "yes";
      tab_bar_edge = "top";
      background_opacity = "0.95";
      shell = "${pkgs.nushell}/bin/nu";

      # Theme (Rose Pine)
      foreground = "#e0def4";
      background = "#191724";
      selection_foreground = "#e0def4";
      selection_background = "#403d52";
      cursor = "#524f67";
      cursor_text_color = "#e0def4";
      url_color = "#c4a7e7";
      active_tab_foreground = "#e0def4";
      active_tab_background = "#26233a";
      inactive_tab_foreground = "#6e6a86";
      inactive_tab_background = "#191724";
      active_border_color = "#31748f";
      inactive_border_color = "#403d52";
      color0 = "#26233a";
      color8 = "#6e6a86";
      color1 = "#eb6f92";
      color9 = "#eb6f92";
      color2 = "#31748f";
      color10 = "#31748f";
      color3 = "#f6c177";
      color11 = "#f6c177";
      color4 = "#9ccfd8";
      color12 = "#9ccfd8";
      color5 = "#c4a7e7";
      color13 = "#c4a7e7";
      color6 = "#ebbcba";
      color14 = "#ebbcba";
      color7 = "#e0def4";
      color15 = "#e0def4";
    };
  };
}
