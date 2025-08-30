{
  pkgs,
  flakeConfig,
  ...
}:
with flakeConfig.system;
{
  imports = [
    hardware-module
    ./options/boot.nix
    ./options/displayManager.nix
    ./options/fonts.nix
    ./options/networking.nix
    ./options/packageExclusions.nix
    ./options/programs.nix
    ./options/security.nix
    ./options/services.nix
    ./options/users.nix
    ./options/virtualisation.nix
    ./options/hardware.nix
  ];

  i18n.defaultLocale = locale;
  time.timeZone = timezone;

  documentation.man = {
    man-db.enable = false;
    mandoc.enable = true;
  };

  environment.stub-ld.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  qt.platformTheme = "kde";

  system.stateVersion = "25.11";
}
