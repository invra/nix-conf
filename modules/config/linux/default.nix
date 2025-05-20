{
  lib,
  user,
  system,
  unstable,
  stable,
  desktop,
  ...
}:
{
  imports = [
    system.hardware-module
    ./stylix.nix
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
  ];

  i18n.defaultLocale = system.locale;
  time.timeZone = system.timezone;
  hardware.graphics.enable = true;
  environment.stub-ld.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ unstable.xdg-desktop-portal-gtk ];
}
