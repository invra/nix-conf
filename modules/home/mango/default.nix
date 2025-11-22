{
  lib,
  linux,
  flakeConfig,
  ...
}:
lib.optionalAttrs linux {
  home.file = lib.optionalAttrs (flakeConfig.desktop.mango.enable or true) {
    ".config/mango/config.conf".text =
      builtins.readFile ./config.conf;
    ".config/mango/startup.sh" = {
      text = builtins.readFile ./startup-script.sh;
      executable = true;
    };
  };
}
