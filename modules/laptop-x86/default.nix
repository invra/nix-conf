{ config, ... }: {
  configurations.nixos.laptop-x86.module = {
    imports = with config.flake.modules.nixos; [
      base
      nvidia-gpu
    ];
    networking = {
      hostId = "0e8e163d";
      hostName = "NixOS";
    };
    facter.reportPath = ./facter.json;
    hardware.nvidia.open = false;
    system.stateVersion = "24.11";
  };
}
