{ unstable, user, ... }:
{
  home = {
    homeDirectory = "/home/${user.username}";
    packages = with unstable; [
      vlc
      wayvnc
      chromium
      parsec-bin
      signal-desktop-bin
    ];
  };
}
