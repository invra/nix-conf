{
  lib,
  linux,
  ...
}:
lib.optionalAttrs linux {
  stylix.targets.waybar.enable = false;
  programs.waybar.enable = true;
  home.file = {
    ".config/waybar/config".text = import ./config.nix;
    ".config/waybar/style.css".text = import ./style.nix;
  };
}
