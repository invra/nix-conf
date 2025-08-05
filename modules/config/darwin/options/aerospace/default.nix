{
  pkgs,
  ...
}:
let
  gaps = 6;
in
{
  imports = [
    ./sketchybar.nix
  ];

  # services.aerospace = {
  #   enable = true;
  # };

  # Disable default menubar, dont worry about yabai here, it will NOT intefere with AeroSpace (iThink)
  services.yabai = {
    enable = true;
    extraConfig = ''
      yabai -m config menubar_opacity 0.0
    '';
  };
}
