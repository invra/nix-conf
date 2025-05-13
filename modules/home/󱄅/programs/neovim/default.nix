{ unstable, neovim-nightly-overlay, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    package = neovim-nightly-overlay.packages.${unstable.system}.default;
  };
}
