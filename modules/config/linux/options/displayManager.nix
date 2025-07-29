{
  pkgs,
  configTOML,
  ...
}:
{
  services.displayManager = with configTOML.system; {
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
