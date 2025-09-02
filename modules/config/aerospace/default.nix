{
  pkgs,
  ...
}:
{
  imports = [
    ../../aerospace.nix
  ];

  services.airspace = {
    enable = true;

    settings = import ./aerospace_toml.nix { inherit pkgs; };
  };

  # Disable default menubar, dont worry about yabai here, it will NOT intefere with AeroSpace (iThink)
  services.yabai = {
    enable = true;
    extraConfig = ''
      yabai -m config focus_follows_mouse autofocus
    '';
  };

  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
  };
}

