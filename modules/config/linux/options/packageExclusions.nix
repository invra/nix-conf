{ unstable, ... }:
let
  pkgs = unstable;
in
{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    dolphin
  ];

  programs.nano.enable = false;
}
