{
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      postman
      prismlauncher
      parsec-bin
      pgadmin4-desktopmode
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
      tldr
      yazi
      wget
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      utm
      tart
      pika
      steam
      raycast
      obs-studio
      linearmouse
      jankyborders
      alt-tab-macos
      betterdisplay
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      wl-clipboard
      wayvnc
      helvum
      easyeffects
      vlc
      gimp3
      pavucontrol
      # davinci-resolve
      signal-desktop-bin
      wayvnc
      libreoffice-qt-fresh
      winetricks
      kdePackages.kdeconnect-kde
      wineWowPackages.waylandFull
    ];

  programs.ripgrep.enable = true;
}
