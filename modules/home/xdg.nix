{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg = lib.mkIf pkgs.stdenv.isLinux {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "LibreWolf.desktop";
        "x-scheme-handler/http" = "LibreWolf.desktop";
        "x-scheme-handler/https" = "LibreWolf.desktop";
        "x-scheme-handler/about" = "LibreWolf.desktop";
        "x-scheme-handler/unknown" = "LibreWolf.desktop";
      };
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      
      desktop = "${config.home.homeDirectory}/desk";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pics";
      publicShare = "${config.home.homeDirectory}/pub";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/vids";
    };
  };
}
