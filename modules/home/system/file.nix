{ ... }:
{
  home.file = {
    ".config/starship.toml" = {
      source = ./config/starship.toml;
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
