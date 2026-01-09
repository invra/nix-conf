{
  inputs,
  lib,
  ...
}:
let
  polyModule = pkgs: linux: {
    stylix = {
      enable = true;
      enableReleaseChecks = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      polarity = "dark";
      image = ../wallpapers/flake.jpg;

      icons = lib.mkIf linux {
        enable = true;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
        package = pkgs.papirus-icon-theme;
      };
      cursor = lib.mkIf linux {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      fonts = lib.mkIf linux {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono Nerd Font";
        };
      };
    };
  };
in
{
  flake.modules = {
    nixos.base =
      { pkgs, ... }:
      {
        imports = [
          inputs.stylix.nixosModules.stylix
          (polyModule pkgs true)
        ];
        stylix.homeManagerIntegration.autoImport = false;
      };

    homeManager.base =
      { pkgs, linux, ... }:
      {
        imports = [
          inputs.stylix.homeModules.stylix
          (polyModule pkgs linux)
        ];
      };
  };
}
