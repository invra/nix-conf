{
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      insomnia
      dbgate
      prismlauncher
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
      obs-studio
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      utm
      pika
      steam
      linearmouse
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
      wayvnc
      libreoffice-qt6-still
      winetricks
      kdePackages.kdeconnect-kde
      wineWowPackages.waylandFull
    ];

  programs.ripgrep.enable = true;
}
