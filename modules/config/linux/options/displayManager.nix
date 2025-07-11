{ unstable, system, ... }:
let
  pkgs = unstable;
in
{
  services.displayManager = {
    gdm = {
      enable = system.greeter == "gdm";
      wayland = true;
    };

    sddm = {
      enable = system.greeter == "sddm";
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
