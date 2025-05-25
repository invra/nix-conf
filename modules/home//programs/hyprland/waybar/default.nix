{ ... }:
{
  stylix.targets.waybar.enable = false;
  programs.waybar.enable = true;
  home.file.".config/waybar" = {
    source = ./config;
    recursive = true;
  };
}
