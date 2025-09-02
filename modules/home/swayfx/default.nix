{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
{
  home = lib.optionalAttrs linux {
    file = {
      ".config/sway/config".text = import ./config.nix;
      ".config/sway/screenshot.nu".text = import ./scripts/screenshot.nix;
      ".config/sway/wallpaper.png".source =
        flakeConfig.user.wallpaper or ../../../wallpapers/flake.jpg;
    };

    packages = with pkgs; [
      playerctl
      wl-clipboard
      grim
      slurp
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

