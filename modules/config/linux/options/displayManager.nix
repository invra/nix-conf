{ unstable, system, ... }:
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

  programs.sway = {
    enable = true;
    package = unstable.swayfx;
  };
}
