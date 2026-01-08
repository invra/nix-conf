{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts = {
        fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];

        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          font-awesome
          liberation_ttf
          noto-fonts
          noto-fonts-color-emoji
        ];
      };
    };
}
