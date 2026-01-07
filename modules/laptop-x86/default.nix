{ config, ... }: {
  configurations.laptop-x86.module = {
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
    fileSystems = {
      "/".device = "/dev/nvme0n1p3";
      "/home".device = "/dev/nvme0n1p4";
    };
    system.stateVersion = "24.11";
  };
}
