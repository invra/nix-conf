{ pkgs, ... }:
let
  osVers = pkgs.rustPlatform.buildRustPackage {
    pname = "os_vers";
    version = "0.1.0";
    src = ./.;
    cargoLock = {
      lockFile = ./Cargo.lock;
    };
  };

  checkVersion = builtins.derivation {
    name = "check-version";
    builder = "${pkgs.bashInteractive}/bin/bash";
    inherit (pkgs) system;
    args = [
      "-c"
      ''
        PATH=${pkgs.uutils-coreutils-noprefix}/bin
        mkdir -p $out
        versionStr=$(${osVers}/bin/os_vers)

        if [ "$versionStr" -ge 26 ]; then
          echo true > $out/result.txt
        else
          echo false > $out/result.txt
        fi
      ''
    ];
  };
in
builtins.readFile "${checkVersion}/result.txt" == "true\n"