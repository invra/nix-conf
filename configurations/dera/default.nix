{
  desktop = {
    hyprland = {
      enable = true;
      monitors = [
        {
          name = "DP-3";
          position = "0x0";
          refreshRate = 180;
          resolution = "2560x1440";
          scale = 1;
        }
      ];
    };
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
      username = "deracul";
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
      dhcpEnabled = true;
      firewallEnabled = false;
      networkmanager = true;
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
    displayName = "dera is a wannabe femboy";
    initialPassword = "111111";
    username = "deracul";
  };
}
