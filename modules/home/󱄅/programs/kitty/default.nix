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
      font-size = 18;
    };
  };
}
