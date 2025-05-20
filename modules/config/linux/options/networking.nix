{ ... }:
{
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
    spiceUSBRedirection.enable = true;
    vmVariant.virtualisation = {
      memorySize = 8192;
      cores = 8;
      diskSize = 128 * 1024;
    };
  };
}
