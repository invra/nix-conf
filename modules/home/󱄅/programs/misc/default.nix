{
  unstable,
  ...
}:
{
  home.packages = with unstable; [
    postman
    parsec-bin
    pgadmin4-desktopmode
    # mongodb-compass
    viu
    chromium
    ffmpeg
    file
    fd
    tree
    unzip
    nil
    nixd
    yt-dlp
    zen
    tldr
    yazi
    remmina
  ];
}
