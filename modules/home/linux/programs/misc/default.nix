{
  pkgs,
  configTOML,
  ...
}:
{
  home = {
    homeDirectory = "/home/${configTOML.user.username}";
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

      wineWowPackages.waylandFull
      winetricks
    ];
  };
}
