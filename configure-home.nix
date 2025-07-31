{
  home-manager,
  extraSpecialArgs,
  plasma-manager,
  zen-browser,
  nixcord,
  stylix,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  inherit extraSpecialArgs;
  modules = [
    plasma-manager.homeManagerModules.plasma-manager
    zen-browser.homeModules.zen-browser
    nixcord.homeModules.nixcord
    stylix.homeModules.stylix
    ./modules/home
  ];
}
