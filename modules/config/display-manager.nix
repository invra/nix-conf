{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
lib.optionalAttrs linux {
  services.displayManager = with flakeConfig.system; {
    gdm = {
      enable = (greeter == "gdm");
      wayland = true;
    };

    sddm = {
      enable = (greeter == "sddm");
      enableHidpi = true;
      wayland.enable = true;
    };
  };
  programs = {
    niri.enable = true;
    sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
