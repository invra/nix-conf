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
      fish
      nushell
    ];

    systemPackages = with pkgs; [
      jack2
      git
      helix
      home-manager
      uutils-diffutils
      uutils-findutils
      uutils-coreutils-noprefix
    ];
  }
  // lib.optionalAttrs linux {
    kde6.excludePackages = with pkgs.kdePackages; [
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

  programs.nano = lib.optionalAttrs linux {
    enable = false;
  };
}
