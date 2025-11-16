{
  lib,
  pkgs,
  linux,
  ...
}:
{
  stylix.targets.fuzzel.enable = false;
  programs.fuzzel = lib.optionalAttrs linux {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        width = 60;
      };
      colors = {
        background = "1f1d2eff";
        text = "6e6a86ff";
        prompt = "6e6a86ff";
        placeholder = "908caaff";
        input = "e0def4ff";
        match = "9ccfd8ff";
        selection-text = "908caaff";
        selection = "26233aff";
        selection-match = "9ccfd8ff";
        counter = "c4a7e7ff";
        border = "ebbcbaff";
      };
    };
  };
}
