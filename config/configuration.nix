user: system:
{ nixpkgs, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://wezterm.cachix.org" "https://cache.iog.io" ];
    trusted-public-keys = [
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  time.timeZone = system.timezone;

  virtualisation = {
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
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    kernelParams = system.kernelParams;
    blacklistedKernelModules = system.graphics.blacklists;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  security.polkit.enable = true;

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
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
  };

  hardware = {
    graphics.enable = true;
  };

  networking = {
    hostName = system.hostname;
    networkmanager.enable = true;
  };

  i18n.defaultLocale = system.locale;
  environment.stub-ld.enable = true;

  programs = {
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    thunar = {
      enable = true;
    };
    virt-manager.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  users.users.${user.username} = {
    isNormalUser = true;
    initialPassword = user.initialPassword;
    description = user.displayName;
    shell = pkgs.nushell;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [ jdk21 remmina gcc clang-tools cmake gnumake ];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      corefonts
      vistafonts
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
  };

  system.stateVersion = "24.11";
}
