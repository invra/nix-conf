{
  unstable,
  ...
}:
{
  home.packages = with unstable; [
    postman
    pgadmin4-desktopmode
    mongodb-compass
    viu
    vlc
    (wrapOBS { plugins = with obs-studio-plugins; [ obs-websocket ]; })
    wayvnc
    ffmpeg
    file
    fd
    tree
    unzip
    yt-dlp
    zen
    chromium
    signal-desktop-bin
    parsec-bin
    remmina
  ];
}
