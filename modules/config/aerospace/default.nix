{
  linux,
  pkgs,
  lib,
  ...
}:
lib.optionalAttrs (!linux) {
  imports = [
    ../../aerospace-module.nix
  ];

  services.airspace = {
    enable = true;

    settings = import ./aerospace_toml.nix { inherit pkgs; };
  };
}
