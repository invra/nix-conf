{
  pkgs,
  ...
}:
{
  environment.shells = with pkgs; [
    bashInteractive
    fish
    nushell
  ];
}
