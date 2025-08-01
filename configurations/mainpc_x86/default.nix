{
  desktop = {
    plasma = {
      enable = true;
    };
  };
  development = {
    git = {
      defaultBranch = "main";
      email = "identificationsucks@gmail.com";
      types = [
        "GitLab"
        "GitHub"
      ];
      username = "Invra";
    };
  };
  system = {
    hardware-module = ./hardware-configuration.nix;
    dock = {
      autoHideDelay = 0.45;
      autohide = true;
      orientation = "right";
    };
    graphics = {
      blacklists = [
        "nouveau"
        "nvidia"
      ];
      wanted = [ "amdgpu" ];
    };
    greeter = "gdm";
    hostname = "NixOS";
    interfaces = { };
    kernelParams = [ "intel_iommu=on" ];
    locale = "en_AU.UTF-8";
    networking = {
      dhcpEnabled = false;
      firewallEnabled = false;
      networkmanager = true;
      interfaces = [
        {
          type = "BRIDGE";
          name = "br0";
          interfaces = [ "enp6s0" ];
          dhcpEnabled = true;
        }
      ];
    };
    services = {
      mongodb = {
        enable = true;
      };
      ssh = {
        enable = true;
      };
    };
    timezone = "Australia/Sydney";
  };
  user = {
    displayName = "Invraa (>.<)";
    initialPassword = "123456";
    username = "invra";
  };
}
