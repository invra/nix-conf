{
  pkgs,
  configTOML,
  ...
}:
{
  home = {
    file = {
      ".config/sway/config".source = ./config;
      ".config/sway/screenshot.nu".text = import ./scripts/screenshot.nix;
      ".config/sway/wallpaper.png".source =
        configTOML.user.wallpaper or ../../../../../wallpapers/flake.jpg;
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
