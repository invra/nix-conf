{
  lib,
  system,
  unstable,
  ...
}:
let
  pkgs = unstable;
in
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
  hardware = {
    graphics.enable = true;
    amdgpu.opencl.enable = lib.mkForce (builtins.elem "amdgpu" (system.graphics.wanted or [ ]));

    nvidia = {
      open = true;
      nvidiaSettings = true;

      prime = {
        intelBusId = system.graphics.nvidia.prime.intelBusId or "";
        nvidiaBusId = system.graphics.nvidia.prime.nvidiaBusId or "";
        amdgpuBusId = system.graphics.nvidia.prime.amdgpuBusId or "";
      };
    };
  };

  documentation.man = {
    man-db.enable = false;
    mandoc.enable = true;
  };

  environment.stub-ld.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  system.stateVersion = "25.11";
}
