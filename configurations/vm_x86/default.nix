{
  desktop.plasma.enable = true;
  development.git = {
    defaultBranch = "main";
    email = "identificationsucks@gmail.com";
    types = [
      "GitLab"
      "GitHub"
    ];
    username = "Invra";
  };
  
  system = {
    hardware-module = ./hardware-configuration.nix;
    graphics = {
      blacklists = [
        "nouveau"
        "amdgpu"
      ];
      wanted = [
        "modesetting"
        "nvidia"
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
      networkmanager = false;
    };
    services = {
      mongodb.enable = true;
      ssh.enable = true;
    };
    timezone = "Australia/Sydney";
  };
  user = {
    displayName = "Invra";
    initialPassword = "123456";
    username = "invra";
  };
}
