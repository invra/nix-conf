{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  dockPkgs = import ../../modules/dock/packages.nix { inherit pkgs; };
  dock = dockPkgs.dock;
in {
  inherit dock;
}