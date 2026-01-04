{ config, ... }:
{
  configurations.nixos.laptop-x86.module = {
    imports = with config.flake.modules.nixos; [
      efi
      workstation
      nvidia-gpu
    ];
  };
}
