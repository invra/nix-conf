{
  pkgs,
  ...
}:
let
  dockPkgs = import ../../modules/dock/packages.nix { inherit pkgs; };
  dock = dockPkgs.dock;
  buildRustPackage = pkgs.rustPlatform.buildRustPackage;

  auto = {
    test = buildRustPackage {
      pname = "test";
      version = "0.1.0";
      src = ../../auto;
      cargoLock = {
        lockFile = ../../auto/Cargo.lock;
      };
    };

    bootstrap-darwin = buildRustPackage {
      pname = "bootstrap-darwin";
      version = "0.1.0";
      src = ../../auto;
      cargoLock = {
        lockFile = ../../auto/Cargo.lock;
      };
    };
  };
in
{
  inherit dock auto;
}
