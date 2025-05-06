{
  development,
  unstable,
  zen-browser,
  ...
}:
{
  home.packages = with unstable; [
    # Developer Tools
    nodejs
    lazygit
    lua
    postman
    ghostty
    pandoc
    pgadmin4-desktopmode
    mongodb-compass

    # Language Servers & Plugins
    marksman
    markdownlint-cli2
    lua-language-server
    bash-language-server
    tailwindcss-language-server
    nushellPlugins.polars
    kde-rounded-corners
    luarocks
    nil

    # Multimedia Tools
    viu
    vlc
    (wrapOBS { plugins = with obs-studio-plugins; [ obs-websocket ]; })
    wayvnc
    ffmpeg
    fzf

    # System Libraries & Utilities
    wl-clipboard
    file
    tree
    waybar
    rofi-wayland
    wofi
    mako
    libnotify
    pavucontrol
    slurp
    grim
    killall
    swww

    # CLI Utilities
    yt-dlp
    wineWowPackages.stable
    superfile

    # Day-to-Day Applications
    zen-browser.outputs.packages.${unstable.system}.default
    chromium
    signal-desktop-bin
    parsec-bin
    obsidian
    prismlauncher
  ];

  programs = {
    home-manager.enable = true;

    ripgrep.enable = true;

    neovim = {
      enable = true;
    };

    nushell = {
      enable = true;
      configFile.source = ./config/config.nu;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };


  };
}
