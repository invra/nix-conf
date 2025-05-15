{unstable, user, ...}: {
  home = {
    homeDirectory = "/home/${user.username}";
    packages = with unstable; [
      chromium
      signal-desktop-bin
      parsec-bin
      vlc
      (wrapOBS { plugins = with obs-studio-plugins; [ obs-websocket ]; })
      wayvnc
    ];
  };
}
