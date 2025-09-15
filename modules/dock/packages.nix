{ pkgs, ... }:

let
  os_vers = pkgs.rustPlatform.buildRustPackage {
    pname = "os_vers";
    version = "0.1.0";
    src = ./.;
    cargoLock = {
      lockFile = ./Cargo.lock;
    };
  };

  checkVersion = pkgs.runCommand "check-version" { } ''
    PATH=${pkgs.uutils-coreutils-noprefix}/bin:${pkgs.coreutils}/bin
    versionStr=$(${os_vers}/bin/os_vers)
    if [ "$versionStr" -ge 26 ]; then
      echo true > $out
    else
      echo false > $out
    fi
  '';

  isAppDrawerCompliant = builtins.readFile checkVersion == "true\n";

in
{
  dock = {
    inherit os_vers checkVersion;
  };

  inherit isAppDrawerCompliant;
}
