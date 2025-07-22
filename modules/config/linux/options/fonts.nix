{
  pkgs,
  ...
}:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      liberation_ttf
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
  };
}
