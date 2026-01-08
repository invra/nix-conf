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

    boot = {
      initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "ahci" "nvme" ];
      kernelModules = [ "kvm-intel" ];
    };
    
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/0522bf8e-6244-4430-a3c6-c5898c9b6b7b";
        fsType = "ext4";
      };
      "/home" = {
        device = "/dev/disk/by-uuid/068428c3-c663-4955-849e-b595841e273f";
        fsType = "ext4";
      };
    };
    system.stateVersion = "24.11";
  };
}
