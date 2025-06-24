{ unstable, ... }:
let
  pkgs = unstable;
in
{
  home.packages = [ pkgs.remmina ];
}
