{
  lib,
  linux,
  ...
}:
lib.optionalAttrs linux {
  stylix.targets.waybar.enable = false;
  programs.waybar.enable = true;
  home.file = {
    ".config/waybar/config" = {
      source = import ./config.nix;
      recursive = true;
    };
    ".config/waybar/style.css" = {
      text = import ./style.nix;
      recursive = true;
    };
  };
}

