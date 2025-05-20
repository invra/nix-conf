{ unstable, ... }:
{
  environment.shells = [
    unstable.bashInteractive
    unstable.zsh
    unstable.fish
    unstable.nushell
  ];
}
