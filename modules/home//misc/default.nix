{ unstable, user, ... }:
{
  home = {
    homeDirectory = "/home/${user.username}";
    packages = with unstable; [
      chromium
      signal-desktop-bin
      parsec-bin
      vlc
      wayvnc
    ];
  };

}
