{
  lib,
  user,
  system,
  unstable,
  stable,
  desktop,
  nixpkgs,
  ...
}:
{
  imports = [
    ./stylix.nix
    ./displayManager.nix
    ./hardware-configuration.nix
  ];

  time.timeZone = system.timezone;

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

  boot = {
    kernelPackages = unstable.linuxKernel.packages.linux_6_14;
    extraModulePackages = with unstable.linuxKernel.packages.linux_6_14; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
    kernelParams = system.kernelParams;
    blacklistedKernelModules = system.graphics.blacklists;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
  };

  security = {
    doas = {
      extraRules = [
        {
          groups = [ "wheel" ];

          keepEnv = true;
          persist = true;
        }
      ];
      enable = true;
    };
    polkit.enable = true;
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    xserver = {

      enable = true;
      videoDrivers = system.graphics.wanted;
      xkb = {
        layout = "us";
        options = "eurosign:e,caps:escape";
      };
    };

    desktopManager.plasma6.enable = desktop.plasma.enable;

    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          securityType = "user";
          "workgroup" = "IDALON";
          "server string" = "Main SMB";
          "netbios name" = "smbnix";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "private" = {
          "path" = "/srv/smb";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "invra";
          "force group" = "wheel";
        };
      };
    };
  };

  environment.plasma6.excludePackages = with unstable.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    dolphin
  ];

  hardware = {
    graphics.enable = true;
  };

  networking = {
    hostName = system.hostname;
    networkmanager.enable = system.networking.networkmanager;
    firewall.enable = system.networking.firewallEnabled;
    useDHCP = lib.mkForce system.networking.dhcpEnabled;

    interfaces = builtins.listToAttrs (
      map (iface: {
        name = iface.name;
        value.useDHCP = (iface.dhcpEnabled or iface.type != "BRIDGE");
      }) system.networking.interfaces or [ ]
    );

    bridges = builtins.listToAttrs (
      map (iface: {
        name = iface.name;
        value.interfaces = (iface.interfaces or [ ]);
      }) (builtins.filter (iface: iface.type == "BRIDGE") system.networking.interfaces or [ ])
    );
  };

  i18n.defaultLocale = system.locale;
  environment.stub-ld.enable = true;

  programs = {
    hyprland.enable = true;
    nano.enable = false;
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    virt-manager.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ unstable.xdg-desktop-portal-gtk ];

  users.users.${user.username} = {
    isNormalUser = true;
    initialPassword = user.initialPassword;
    description = user.displayName;
    shell = unstable.nushell;
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "libvirtd"
    ];
    packages = with unstable; [
      wayvnc
      wget
      jdk21
      glib
      libreoffice-qt-fresh
      remmina
      gcc
      clang-tools
      cmake
      calibre
      gnumake
    ];
  };

  fonts = {
    packages = with unstable; [
      nerd-fonts.jetbrains-mono
      font-awesome
      liberation_ttf
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
  };

  system.stateVersion = "24.11";
}
