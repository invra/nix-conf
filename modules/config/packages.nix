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
    
    excludePackages = lib.optionals linux (with pkgs.kdePackages; [
      plasma-browser-integration
      gwenview
      discover
      dolphin
      konsole
      oxygen
      okular
      elisa
      kate
    ]);
  };


  programs.nano.enable = false;
}
