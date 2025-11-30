{
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
        "application/x-desktop" = "alacritty.desktop";
      };
    };
  };
}
