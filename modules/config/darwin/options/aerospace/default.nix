{
  pkgs,
  ...
}:
let
  gaps = 6;
in
{
  imports = [
    ./module.nix
    ./sketchybar.nix
  ];

  services.airspace = {
    enable = true;

    settings = ./aerospace.toml;
  };

  # Disable default menubar, dont worry about yabai here, it will NOT intefere with AeroSpace (iThink)
  services.yabai = {
    enable = true;
    extraConfig = ''
      yabai -m config focus_follows_mouse autofocus
    '';
  };
}
