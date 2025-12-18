{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
lib.optionalAttrs linux {
  home.file = lib.optionalAttrs (flakeConfig.desktop.mangowc.enable or false) {
    ".config/mango/config.conf".text = import ./config.nix { inherit pkgs; };
    ".config/mango/startup.sh" = {
      text = builtins.readFile ./startup-script.sh;
      executable = true;
    };
  };
}
