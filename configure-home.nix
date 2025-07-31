{
  home-manager,
  extraSpecialArgs,
  plasma-manager,
  zen-browser,
  nixcord,
  stylix,
  nixpkgs,
  system,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  inherit extraSpecialArgs;
  pkgs = import nixpkgs { inherit system; };
  modules = [
    plasma-manager.homeManagerModules.plasma-manager
    zen-browser.homeModules.zen-browser
    nixcord.homeModules.nixcord
    stylix.homeModules.stylix
    ./modules/home
  ];
}
