{ inputs, ... }: {
  flake.modules.nixos.base = { pkgs, lib,  ... }: {
    imports = [
      inputs.mango.nixosModules.mango
    ];
    config = lib.mkIf pkgs.stdenv.isLinux {
      services.displayManager.ly.enable = true;
      programs.mango.enable = true; 

      environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config = {
          preferred = {
            default = "gtk";
            "org.freedesktop.impl.portal.ScreenCast" = "wlr";
            "org.freedesktop.impl.portal.Screenshot" = "wlr";
          };
        };
      };
    };
  };
}