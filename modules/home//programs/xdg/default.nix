{ unstable, ... }:
let
  pkgs = unstable;
in
{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
        "application/x-desktop" = "ghostty.desktop";
      };
    };
    desktopEntries = {
      zen = {
        name = "Zen Browser";
        exec = "${pkgs.zen}/bin/zen";
      };

      ghostty = {
        name = "Ghostty";
        exec = "${pkgs.ghostty}/bin/ghostty";
      };
    };
  };
}
