{
  pkgs,
  ...
}:
let
  analygits = pkgs.rustPlatform.buildRustPackage {
    pname = "analygits";
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
    analygits
  ];
}
