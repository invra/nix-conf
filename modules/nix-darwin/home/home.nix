{
  config,
  unstable,
  development,
  neovim-nightly-overlay,
  ...
}:
let
  userName = development.git.username;
  userEmail = development.git.email;
  initialBranch = development.git.defaultBranch;
  pkgs = unstable;

  vencord-discord = pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
  };
in
{
  imports = [
    ./system/fastfetch.nix
    ./dock.nix
    ./spicetify.nix
  ];
  home = {
    stateVersion = "23.05";

    packages = with pkgs; [
      # Usability of System.
      aerospace
      file
      tree
      jankyborders
      sketchybar

      # Developer
      postman
      lazygit
      license-go
      dotnetCorePackages.dotnet_9.sdk

      # Games
      prismlauncher

      # Day-to-day Applications / tools
      vencord-discord
      vesktop
      remmina
    ];

    file = {
      ".config/ghostty" = {
        source = ./system/config/ghostty;
        recursive = true;
      };
      ".config/btop" = {
        source = ./system/config/btop;
        recursive = true;
      };
      ".hushlogin" = {
        source = ./system/config/null;
      };
      ".config/starship.toml" = {
        source = ./system/config/starship.toml;
      };
      "Library/Keyboard Layouts" = {
        source = ./system/config/Kbd;
        recursive = true;
      };
      ".config/zed" = {
        source = ./system/config/zed;
        recursive = true;
      };
      ".config/nvim" = {
        source = ./system/config/neovim;
        recursive = true;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      initContent = ''
        if [[ ! $(ps -T -o "comm" | tail -n +2 | grep "nu$") && -z $ZSH_EXECUTION_STRING ]]; then
            if [[ -o login ]]; then
                LOGIN_OPTION='--login'
            else
                LOGIN_OPTION='''
            fi
            exec nu "$LOGIN_OPTION"
        fi
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
    gh = {
      enable = true;
    };
    zed-editor = {
      enable = true;
    };
    vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        pkief.material-icon-theme
        bradlc.vscode-tailwindcss
        vscodevim.vim
        ms-vsliveshare.vsliveshare
        ms-vscode.live-server
        kamikillerto.vscode-colorize
        bierner.github-markdown-preview
        mvllow.rose-pine
      ];
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
    nushell = {
      enable = true;
      configFile.source = ./system/config/nushell/config.nu;
    };
    ripgrep.enable = true;
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
      package = neovim-nightly-overlay.packages.${pkgs.system}.default;
    };
    git = {
      enable = true;
      inherit userName userEmail;

      extraConfig = {
        init.defaultBranch = initialBranch;
      };
    };
  };

  local = {
    dock.enable = true;
    dock.entries = [
      { path = "/Applications/Zen.app"; }
      { path = "${pkgs.zed-editor}/Applications/Zed.app"; }
      { path = "/Applications/Ghostty.app"; }
      { path = "${vencord-discord}/Applications/Discord.app"; }
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Spotify.app"; }
    ];
  };
}
