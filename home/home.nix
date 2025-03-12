spicePkgs: pkgs: inputs:
{ development, user, pkgs, stable, ... }: {
  imports = [
    (import ./system/fastfetch.nix development)
    ./system/hyprland.nix
    (import ./spicetify.nix spicePkgs pkgs inputs)
  ];
  home = {
    username = user.username;
    homeDirectory = "/home/" + user.username;
    stateVersion = "24.11";
    packages = with pkgs; [
        # Developer Tools
        python312
        lazygit
        lua
        postman
        ghostty
        pandoc

        # Language Servers & Plugins
        marksman
        markdownlint-cli2
        lua-language-server
        bash-language-server
        tailwindcss-language-server
        vimPlugins.nvim-treesitter-parsers.fsharp
        nushellPlugins.polars
        kde-rounded-corners
        luarocks
        nil

        # Multimedia Tools
        viu
        vlc
        obs-studio
        ffmpeg
        fzf

        # System Libraries & Utilities
        wl-clipboard
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
        btop
        superfile

        # Day-to-Day Applications
        inputs.zen-browser.packages."${system}".generic
        vesktop
        signal-desktop
        parsec-bin
        obsidian
        prismlauncher
    ];
    file = {
      ".config/starship.toml" = {
        source = ./system/config/starship.toml;
      };
      ".config/nvim" ={
        source = ./system/config/neovim;
	      recursive = true;
      };
      ".config/waybar" = {
        source = ./system/config/waybar;
	      recursive = true;
      };
      ".config/mako" = {
        source = ./system/config/mako;
	      recursive = true;
      };
      ".config/btop/btop.conf" = {
        source = ./system/config/btop/btop.conf;
      };
      ".wallpapers" = {
        source = ./system/config/.wallpapers;
        recursive = true;
      };
      ".config/ghostty" = {
        source = ./system/config/ghostty;
        recursive = true;
      };
      ".config/fastfetch/nixos.png" = {
        source = ./system/config/fastfetch/nixos.png;
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };

  programs = {
    lf.enable = true;
    ripgrep.enable = true;
    home-manager.enable = true;
    git = {
      enable = true;
      userName  = development.git.username;
      userEmail = development.git.email;

      extraConfig = {
        init.defaultBranch = development.git.defaultBranch;
      };
    };
    gh = {
      enable = true;
      settings = { editor = "nvim"; };
    };
    zed-editor = {
      enable = true;
    };
    nushell = {
      enable = true;
      configFile.source = ./system/config/config.nu;
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    };
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
