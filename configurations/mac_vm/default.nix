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
      username = "InvraNet";
    };
  };
  system = {
    normaliseKbd = true;
    dock = {
      autoHideDelay = 0.45;
      autohide = true;
      orientation = "right";
    };
    graphics = {
      blacklists = [ ];
      wanted = [ ];
    };
    greeter = "gdm";
    hostname = "NixOS";
    interfaces = { };
    kernelParams = [ ];
    locale = "en_AU.UTF-8";
    networking = {
      dhcpEnabled = true;
      firewallEnabled = false;
      networkmanager = true;
    };
    services = {
      mongodb.enable = true;
      ssh.enable = true;
    };
    timezone = "Australia/Sydney";
  };
  user = {
    displayName = "InvraNet";
    initialPassword = "123456";
    username = "invra";
  };
}
