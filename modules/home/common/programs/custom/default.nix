{ pkgs, ... }:

let
  gc = pkgs.rustPlatform.buildRustPackage rec {
    pname = "gc";
    version = "0.1.0";
    src = ./gc;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
      openssl
    ];

    buildInputs = with pkgs; [
      openssl
    ];
  };

  dev = pkgs.rustPlatform.buildRustPackage rec {
    pname = "dev";
    version = "0.1.0";
    src = ./dev;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];
  };
in {
  home.packages = [
    dev
    gc
  ];
}
