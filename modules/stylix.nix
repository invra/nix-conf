{
  inputs,
  ...
}:
let
  polyModule = pkgs: {
    stylix = {
      enable = true;
      enableReleaseChecks = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      polarity = "dark";
      # image = flakeConfig.user.wallpaper or ../../wallpapers/flake.jpg;
      image = ../wallpapers/flake.jpg;

      
      icons = {
        enable = true;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
        package = pkgs.papirus-icon-theme;
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      fonts = {
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
    nixos.base = { pkgs, ... }: {
      imports = [
        inputs.stylix.nixosModules.stylix
        (polyModule pkgs)
      ];
      stylix.homeManagerIntegration.autoImport = false;
    };

    homeManager.base = { pkgs, ... }: {
      imports = [
        inputs.stylix.homeModules.stylix
        (polyModule pkgs)
      ];
    };
  };
}
