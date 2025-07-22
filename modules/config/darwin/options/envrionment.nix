{
  pkgs,
  ...
}:
{
  environment.shells = [
    pkgs.bashInteractive
    pkgs.zsh
    pkgs.fish
    pkgs.nushell
  ];
}
