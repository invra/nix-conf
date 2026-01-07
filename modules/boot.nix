{ inputs, ... }: {
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {
    imports = [ inputs.ucodenix.nixosModules.default ];

    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
     
      kernelParams = lib.optional config.services.ucodenix.enable "microcode.amd_sha_check=off";
      
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
      '';

      loader = {
        systemd-boot.enable = false;
        grub = {
          enable = true;
          devices = [ "/dev/vda" ];
        };
      };  
      kernel.sysctl = {
        "vm.max_map_count" = 2147483642;
        "vm.swappiness" = 10;
      };
    };
  };
}