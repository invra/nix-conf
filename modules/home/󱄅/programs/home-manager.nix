{
  unstable,
  neovim-nightly-overlay,
  ...
}:
let
  pkgs = unstable;
in
{
  programs = {
    home-manager.enable = true;
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
  };

}
