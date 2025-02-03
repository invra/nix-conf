{ config, pkgs, lib, ... }:

let
  tomlConfig = builtins.fromTOML (builtins.readFile ../../config.toml);
  hyprland = tomlConfig.desktop.hyprland;
  wallpapers = hyprland.wallpapers;
in
{
  services.hyprpaper = {
    enabled = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      wallpaper = wallpapers;
    };
  };
}
