{ unstable, desktop, ... }:
{
  imports = [
    ./mako
    ./waybar
    ./rofi
  ];


  home = {
    file.".config/sway/config".source = ./config;

    packages = with unstable; [
      playerctl
      
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
