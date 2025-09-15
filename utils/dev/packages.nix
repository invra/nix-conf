{
  pkgs,
  ...
}:
let
  dockPkgs = import ../../modules/dock/packages.nix { inherit pkgs; };
  dock = dockPkgs.dock;
  # buildRustPackage = pkgs.rustPlatform.buildRustPackage;
in
{
  inherit dock;
}
