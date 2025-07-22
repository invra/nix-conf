{
  pkgs,
  ...
}:
{
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    dolphin
    discover
    kate
    gwenview
    okular
  ];

  programs.nano.enable = false;
}
