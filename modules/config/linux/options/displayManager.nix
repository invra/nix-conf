{ unstable, system, ... }:
{
  services.xserver.displayManager.gdm = {
    enable = system.greeter == "gdm";
    wayland = true;
  };
  programs.sway = {
    enable = true;
    package = unstable.swayfx;
  }; 
}
