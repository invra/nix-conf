{ inputs, ... }:
{
  flake.modules.nixos.base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [ inputs.ucodenix.nixosModules.default ];

      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = lib.optional config.services.ucodenix.enable "microcode.amd_sha_check=off";
        loader.systemd-boot.enable = true;

        kernel.sysctl = {
          "vm.max_map_count" = 2147483642;
          "vm.swappiness" = 10;
        };
      };
    };
}
