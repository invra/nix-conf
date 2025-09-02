{
  pkgs,
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
  };
}
