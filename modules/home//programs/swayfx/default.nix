{
  unstable,
  ...
}:
{
  home = {
    file = {
      ".config/sway/config".source = ./config;
      ".config/sway/screenshot.nu".text = import ./scripts/screenshot.nix;
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
