{
  desktop = {
    plasma.enable = true;
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
    hardware-module = ./hardware/vm-aarch64.nix;
    graphics = {
      blacklists = [
        "nouveau"
        "nvidia"
        "amdgpu"
      ];
      wanted = [ "modesetting" ];
    };
    greeter = "gdm";
    hostname = "NixOS";
    interfaces = { };
    locale = "en_AU.UTF-8";
    networking = {
      dhcpEnabled = true;
      firewallEnabled = false;
      networkmanager = true;
    };
    services = {
      ssh = {
        enable = true;
      };
    };
    timezone = "Australia/Sydney";
    boot.efiDirectory = "/boot";
  };
  user = {
    displayName = "Invra";
    initialPassword = "123456";
    username = "invra";
  };
}
