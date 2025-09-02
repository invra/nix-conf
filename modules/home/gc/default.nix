{
  pkgs,
  ...
}:
let
  gc = pkgs.rustPlatform.buildRustPackage {
    pname = "gc";
    version = "0.1.0";
    src = ./.;

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    buildInputs = with pkgs; [
      openssl
    ];

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];
  };
in
{
  home.packages = [
    gc
  ];
}
