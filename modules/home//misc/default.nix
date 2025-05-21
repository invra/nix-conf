{ unstable, user, ... }:
{
  home = {
    homeDirectory = "/home/${user.username}";
    packages = with unstable; [
      vlc
      wayvnc
      helvum
      chromium
      parsec-bin
      easyeffects
      pavucontrol
      signal-desktop-bin
    ];
  };
}
