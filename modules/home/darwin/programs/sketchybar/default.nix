{ pkgs, ... }:
let
  helpers = import ./packages { inherit (pkgs) rustPlatform; };
in
{
  home.packages = [ pkgs.lua ];
  programs.sketchybar = {
    enable = true;
    configType = "lua";
    config = {
      source = ./config;
      recursive = true;
    };
    includeSystemPath = true;

    extraPackages = with helpers; [
      network_load
      memory_load
      cpu_load
      menus
    ];
  };
}
