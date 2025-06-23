{ unstable, user, ... }:
{
  home = {
    homeDirectory = "/home/${user.username}";
    packages = with unstable; [
      vlc
      gimp3
      wayvnc
      helvum
      easyeffects
      pavucontrol
      # davinci-resolve
      signal-desktop-bin
    ];
  };
}
