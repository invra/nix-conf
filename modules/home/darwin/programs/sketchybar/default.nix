{ pkgs, ... }:

{
  home.packages = [pkgs.lua];
  programs.sketchybar = {
    enable = true;
    configType = "lua";
    config = {
      source = ./config;
      recursive = true;
    };
    includeSystemPath = true;
  };
}
