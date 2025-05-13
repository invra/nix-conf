 {
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
in
{
  programs = {
    home-manager.enable = true;
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

}
