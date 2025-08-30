{
  desktop = {
    plasma = {
      enable = true;
    };
  };
  development = {
    git = {
      defaultBranch = "main";
      email = "lurker4youu@gmail.com";
      types = [
        "GitHub"
      ];
      username = "deracull";
    };
  };
  system = {
    hardware-module = ./hardware-configuration.nix;
    graphics = {
      blacklists = [
        "nouveau"
        "nvidia"
      ];
      wanted = [
        "modesetting"
        "amdgpu"
      ];
    };
    greeter = "gdm";
    hostname = "NixOS";
    interfaces = { };
    kernelParams = [ "intel_iommu=on" ];
    locale = "en_AU.UTF-8";
    networking = {
      dhcpEnabled = true;
      firewallEnabled = false;
      networkmanager = true;
    };
    services = {
      mongodb = {
        enable = false;
      };
      ssh = {
        enable = true;
      };
    };
    timezone = "Asia/Dubai";
    boot.efiDirectory = "/boot";
  };
  user = {
    displayName = "dera is a wannabe femboy";
    initialPassword = "111111";
    username = "deracul";
  };
}
