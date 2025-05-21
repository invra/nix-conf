{ unstable, ... }:
{
  stylix.targets.zed.enable = false;
  programs.zed-editor = {
    enable = true;
    extensions = [
      "rose-pine-theme"
      "html"
      "nix"
      "discord-presence"
    ];
    extraPackages = [ unstable.nixd ];
    userSettings = {
      telemetry.metrics = false;
      ui_font_size = 16;
      tab_size = 2;
      buffer_font_size = 16;
      vim_mode = true;
      theme = {
        mode = "system";
        light = "Rosé Pine";
        dark = "Rosé Pine";
      };
      terminal = {
        line_height = "standard";
        font_family = "Hack";
      };
    };
  };
}
