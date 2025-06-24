{ unstable, ... }:
let
  pkgs = unstable;
in
{
  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
    pkgs.nushell
  ];
}
