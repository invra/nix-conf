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
      username = "InvraNet";
    };
  };
  system = {
    dock = {
      autoHideDelay = 0.45;
      autohide = true;
      orientation = "bottom";
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
    displayName = "peter";
    initialPassword = "123456";
    username = "peter";
  };
}
