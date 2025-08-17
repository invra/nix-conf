{
  pkgs,
  ...
}:
{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    gwenview
    discover
    dolphin
    konsole
    oxygen
    okular
    elisa
    kate
  ];

  programs.nano.enable = false;
}
