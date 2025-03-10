spicePkgs: inputs:
{ development, user, pkgs, stable, ... }: {
  imports = [
    ./system/fastfetch.nix
    ./system/hyprland.nix
    (import ./spicetify.nix spicePkgs inputs)
  ];
  home = {
    username = user.username;
    homeDirectory = "/home/" + user.username;
    stateVersion = "24.11";
    packages = with pkgs; [

      # Developer
      lua-language-server
      python312
      luarocks
      lua
      nil
      obs-studio
      ffmpeg
      lazygit
      markdownlint-cli2
      marksman
      parsec-bin
      fzf
      btop
      postman
      bash-language-server
      vesktop
      wl-clipboard
      nushellPlugins.polars
      waybar
      rofi-wayland
      wofi
      mako
      libnotify
      inputs.zen-browser.packages."${system}".generic
      signal-desktop
      pavucontrol
      slurp
      grim
      obsidian
      killall
      kde-rounded-corners
      pandoc
      prismlauncher
      swww
    ];
    file = {
      ".config/starship.toml" = {
        source = ./system/config/starship.toml;
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
    wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = builtins.readFile ./system/config/wezterm.lua;
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
