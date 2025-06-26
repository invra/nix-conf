{ unstable, ... }:
let
  pkgs = unstable;
in
{
  home.packages = [ pkgs.wl-clipboard ];
}
