{
  linux,
  pkgs,
  lib,
  ...
}:
lib.optionalAttrs (!linux) {
  imports = [
    ../../aerospace.nix
  ];

  services.airspace = {
    enable = true;

    settings = import ./aerospace_toml.nix { inherit pkgs; };
  };
}
