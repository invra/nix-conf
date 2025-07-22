{
  pkgs,
  ...
}:
{
  programs.obs-studio = with pkgs; {
    enable = true;
    package = obs-studio;
  };
}
