{ pkgs, ... }:

{
  home.packages = with pkgs; [lua];
  programs.sketchybar = {
    enable = true;
  };

  home.file = {
    ".config/sketchybar" = {
      source = ./config;
      recursive = true;
    };
  };
}
