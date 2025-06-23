{ unstable, desktop, ... }:
{
  imports = [
    ./mako
    ./waybar
    ./rofi
  ];

  home = {
    file = {
      ".config/sway/config".source = ./config;
      ".config/sway/screenshot.nu".source = ./screenshot.nu;
      ".config/sway/wallpaper.png".source = ../../../../../wallpapers/flake.jpg;
    };

    packages = with unstable; [
      playerctl
      wl-clipboard
      grim
      slurp
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
