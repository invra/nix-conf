{ unstable, system, ... }:
let
  pkgs = unstable;
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with pkgs; [ linuxPackages_latest.v4l2loopback.out ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
    kernelParams = system.kernelParams;
    blacklistedKernelModules = system.graphics.blacklists;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
  };
}
