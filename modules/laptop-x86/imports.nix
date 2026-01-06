{ config, ... }:
{
  configurations.nixos.laptop-x86.module = {
    imports = with config.flake.modules.nixos; [
      base
      nvidia-gpu
    ];
  };
}
