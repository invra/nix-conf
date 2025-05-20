{ unstable, ... }: {
  environment.plasma6.excludePackages = with unstable.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    dolphin
  ];

  programs.nano.enable = false;
}
