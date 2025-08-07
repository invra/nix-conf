{
  pkgs,
  flakeConfig,
  ...
}:
{
  home = {
    homeDirectory = "/home/${flakeConfig.user.username}";
    packages = with pkgs; [
      vlc
      gimp3
      wayvnc
      helvum
      easyeffects
      pavucontrol
      # davinci-resolve
      signal-desktop-bin
      wayvnc
      wget
      jdk21
      libreoffice-qt-fresh
      winetricks

      kdePackages.kdeconnect-kde
      wineWowPackages.waylandFull
    ];
  };
}
