{ pkgs, ... }:

let
  gc = pkgs.rustPlatform.buildRustPackage rec {
    pname = "gc";
    version = "0.1.0";
    src = ./gc;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.openssl
    ];

    buildInputs = [
      pkgs.openssl
    ];
  };
in {
  home.packages = [
    gc
  ];
}
