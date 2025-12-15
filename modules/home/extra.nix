{
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      sl
      dbgate
      prismlauncher
      viu
      librewolf
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
      uutils-diffutils
      uutils-findutils
      uutils-coreutils-noprefix
    ]
    ++ lib.optionals (!(stdenv.isLinux && stdenv.isAarch64)) [
      insomnia
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      steam
      utm
      pika
      linearmouse
      obs-studio
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
      kdePackages.kdeconnect-kde
    ]
    ++ (lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
      wineWowPackages.waylandFull
      winetricks
      yabridge
      (yabridgectl.override { wine = wineWowPackages.waylandFull; })
      bitwig-studio
    ]);

  programs.ripgrep.enable = true;
}
