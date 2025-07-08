{
  unstable,
  ...
}:
let
  pkgs = unstable;

  ghostty =
    if pkgs.stdenv.isDarwin then
      pkgs.ghostty-bin
    else if pkgs.stdenv.isLinux then
      pkgs.ghostty
    else
      throw "Unsupported platform: only Darwin and Linux are supported";
in
{
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    package = ghostty;
    enable = true;

    settings = {
      theme = "rose-pine";
      background-opacity = 0.95;
      gtk-single-instance = true;
      font-size = 14;
    };
  };
}
