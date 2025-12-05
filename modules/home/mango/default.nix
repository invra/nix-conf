{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
lib.optionalAttrs linux {
  home.packages = with pkgs; [
    hyprshot
  ];

  home.file = lib.optionalAttrs (flakeConfig.desktop.mangowc.enable or false) {
    ".config/mango/config.conf".text = builtins.readFile ./config.conf;
    ".config/mango/startup.sh" = {
      text = builtins.readFile ./startup-script.sh;
      executable = true;
    };
  };
}
