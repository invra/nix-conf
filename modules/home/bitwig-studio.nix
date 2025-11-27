{
  nixpkgs-24_11,
  pkgs,
  lib,
  ...
}:
let
  pkgs-24_11 = import nixpkgs-24_11 { inherit (pkgs) system; };
in
{
  home.packages = lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) (
    with pkgs;
    [
      yabridge
      (yabridgectl.override { wine = wineWowPackages.waylandFull; })
      bitwig-studio
    ]
  );
}
