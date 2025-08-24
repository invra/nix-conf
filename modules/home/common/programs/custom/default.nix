{ pkgs, ... }:
let
  gc = pkgs.rustPlatform.buildRustPackage rec {
    pname = "gc";
    version = "0.1.0";
    src = ./gc;
    cargoLock.lockFile = "${src}/Cargo.lock";

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      openssl
    ];
  };

  analygits = pkgs.rustPlatform.buildRustPackage rec {
    pname = "analygits";
    version = "0.0.1";
    src = ./analygits;
    cargoLock.lockFile = "${src}/Cargo.lock";

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      openssl
    ];
  };

  dev = pkgs.rustPlatform.buildRustPackage rec {
    pname = "dev";
    version = "0.1.0";
    src = ./dev;
    cargoLock.lockFile = "${src}/Cargo.lock";

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];
  };
in
{
  home.packages = [
    analygits
    dev
    gc
  ];
}
