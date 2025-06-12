{ unstable, ... }:
let
  pkgs = unstable;
in
{
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
  };
}
