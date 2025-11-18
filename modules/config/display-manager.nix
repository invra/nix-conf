{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
lib.optionalAttrs linux {
  services = {
    displayManager = with flakeConfig.system; {
      gdm = {
        enable = (greeter == "gdm");
        wayland = true;
      };
      
      ly.enable = (greeter == "ly");

      cosmic-greeter.enable = (greeter == "cosmic");

      sddm = {
        enable = (greeter == "sddm");
        enableHidpi = true;
        wayland.enable = true;
      };
    };
    desktopManager.cosmic.enable = flakeConfig.desktop.cosmic.enable or false;
  };
  programs = {
    river-classic.enable = true;
    niri.enable = flakeConfig.desktop.niri.enable or false;
    sway = {
      enable = flakeConfig.desktop.swayfx.enable or false;
      package = pkgs.swayfx;
    };
    hyprland = {
      enable = flakeConfig.desktop.hyprland.enable or false;
      xwayland.enable = true;
    };
  };

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-gnome
      # xdg-desktop-portal-gtk
      xdg-desktop-portal-cosmic
      # xdg-desktop-portal-wlr
      # xdg-desktop-portal-hyprland
    ];
  };
}
