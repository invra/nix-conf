{
  pkgs,
  ...
}:
let
  dev = pkgs.rustPlatform.buildRustPackage {
    pname = "dev";
    version = "0.1.0";
    src = ./.;
    cargoLock = {
      lockFile = ./Cargo.lock;
    };
  };
in
{
  home.packages = [
    dev
  ];
}

