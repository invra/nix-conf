{ ... }:
{
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "rose-pine";
      font-size = 10;
      background-opacity = 0.85;
      background-blur = true;
    };
  };
}
