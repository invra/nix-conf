{ lib, ... }: {
  flake.modules.homeManager.base =
    { config, pkgs, linux, ... }:
    {
      config = lib.optionalAttrs linux {
        xdg = {
          enable = true;
          mime.enable = true;
          mimeapps = {
            enable = true;
            defaultapplications = {
              "text/html" = "librewolf.desktop";
              "x-scheme-handler/http" = "librewolf.desktop";
              "x-scheme-handler/https" = "librewolf.desktop";
              "x-scheme-handler/about" = "librewolf.desktop";
              "x-scheme-handler/unknown" = "librewolf.desktop";
            };
          };

          userdirs = {
            enable = true;
            createdirectories = true;

            desktop = "${config.home.homedirectory}/desk";
            documents = "${config.home.homedirectory}/docs";
            download = "${config.home.homedirectory}/downloads";
            music = "${config.home.homedirectory}/music";
            pictures = "${config.home.homedirectory}/pics";
            publicshare = "${config.home.homedirectory}/pub";
            templates = "${config.home.homedirectory}/templates";
            videos = "${config.home.homedirectory}/vids";
          };
        };

        home.packages = with pkgs; [
          xdg-utils
        ];
      };
    };
}
