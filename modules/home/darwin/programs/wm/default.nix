{ pkgs, ... }:

{
  home.packages = with pkgs; [ lua ];
  programs.sketchybar = {
    enable = true;
    configType = "lua";
    config = {
      source = ./config;
      recursive = true;
    };
    includeSystemPath = true;
  };

  programs.aerospace.enable = true;
  # TODO
  # Aerospace can't be configured through HM due to HM
  # using "", but for the call to sketchybar needs '' -
  # - some bullshit probably to fix later.
  home.file.".config/aerospace/aerospace.toml" = {
    source = pkgs.lib.mkForce ./aerospace-config.toml;
  };
}
