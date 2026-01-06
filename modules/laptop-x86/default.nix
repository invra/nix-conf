{ config, ... }: {
  configurations.nixos.laptop-x86.module = {
    networking = {
      hostId = "0e8e163d";
      hostName = "NixOS";
    };
    facter.reportPath = ./facter.json;
    imports = with config.flake.modules.nixos; [
      base
      nvidia-gpu
    ];
    hardware.nvidia.open = false;
    system.stateVersion = "24.11";
  };
}

