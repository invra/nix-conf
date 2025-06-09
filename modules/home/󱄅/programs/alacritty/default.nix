{
  unstable,
  ...
}:
let
  pkgs = unstable;
in
{
  programs.alacritty = {
    enable = true;
  };
}