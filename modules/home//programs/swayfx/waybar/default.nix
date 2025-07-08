{ ... }:
{
  stylix.targets.waybar.enable = false;
  programs.waybar.enable = true;
  home.file.".config/waybar/config" = {
    source = ./config/config;
    recursive = true;
  };
  home.file.".config/waybar/style.css" = {
    text = import ./config/stylecss.nix;
    recursive = true;
  };
}
