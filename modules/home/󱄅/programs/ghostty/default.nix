{ unstable, ... }:
{
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = !unstable.ghostty.meta.broken;
    settings = {
      theme = "rose-pine";
      font-size = 10;
      background-opacity = 0.85;
      background-blur = true;
    };
  };
}
