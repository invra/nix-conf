{ unstable, ... }:
{
  fonts = {
    packages = with unstable; [
      nerd-fonts.jetbrains-mono
      font-awesome
      liberation_ttf
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
  };
}
