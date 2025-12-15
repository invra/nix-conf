{
  lib,
  pkgs,
  linux,
  ...
}:
{
  environment = {
    shells = with pkgs; [
      bashInteractive
      nushell
    ];

    systemPackages =
      with pkgs;
      [
        jack2
        git
        helix
        home-manager
      ]
      ++ lib.optionals linux [
        lsof
        alacritty
        foot
        librewolf
        helium
        pciutils
        nautilus
        xwayland-satellite
        swww
      ];
  }
  // lib.optionalAttrs linux {
    plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      gwenview
      discover
      dolphin
      konsole
      oxygen
      okular
      elisa
      kate
    ];
  };

  programs = lib.optionalAttrs linux {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libx11
        libxcursor
        libxkbcommon
        libxrender
        libxrandr
      ];
    };
    virt-manager.enable = true;
    dconf.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alactritty";
    };
    nano.enable = false;
    steam = {
      enable = true;
      extraPackages = with pkgs; [
        qogir-icon-theme
        steamtinkerlaunch
      ];
      extraCompatPackages = with pkgs; [
        steamtinkerlaunch
      ];
    };
  };
}
