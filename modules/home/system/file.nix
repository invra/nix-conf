{ ... }:
{
  home.file = {
    ".config/starship.toml" = {
      source = ./config/starship.toml;
    };
    ".config/nvim" = {
      source = ./config/neovim;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./config/waybar;
      recursive = true;
    };
    ".config/mako" = {
      source = ./config/mako;
      recursive = true;
    };

    ".config/Code/User/settings.json" = {
      source = ./config/vscode/settings.json;
    };
    ".config/hyprpanel" = {
      source = ./config/hyprpanel;
      recursive = true;
    };
  };
}
