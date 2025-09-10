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
    hardware-module = ./hardware/vm-x86.nix;
    graphics = {
      blacklists = [ ];
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
  };
  user = {
    displayName = "Invra";
    initialPassword = "123456";
    username = "invra";
  };
}
