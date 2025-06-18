{
  unstable,
  ...
}:
let
  pkgs = unstable;
in
{
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    package = pkgs.ghostty-bin;
    enable = true;

    settings = {
      theme = "rose-pine";
      background-opacity = 0.95;
      font-size = 14;
    };
  };
}
