spicePkgs: inputs:
{ pkgs, stable, ... }: {
  imports = [
    ./fastfetch.nix
    (import ./spicetify.nix spicePkgs inputs)
  ];
  home = {
    username = "invra";
    homeDirectory = "/home/invra";
    stateVersion = "24.11";
    packages = with pkgs; [

      # Developer
      lua-language-server
      luarocks
      lua
      nil
      obs-studio
      ffmpeg
      lazygit
      markdownlint-cli2
      marksman
      fzf
      btop
      bash-language-server
      vesktop
      wl-clipboard
      nushellPlugins.polars
      waybar
      rofi-wayland
      wofi
      mako
      swww
      libnotify
      inputs.zen-browser.packages."${system}".generic
      signal-desktop
      pavucontrol
      slurp
      grim
      obsidian
      killall
    ];
    file = {
      ".config/starship.toml" = {
        source = ./starship.toml;
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
      userName  = "InvraNet";
      userEmail = "identificationsucks@gmail.com";
    };
    gh = {
      enable = true;
      settings = { editor = "nvim"; };
    };
    wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
    zed-editor = {
      enable = true;
    };
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
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
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
