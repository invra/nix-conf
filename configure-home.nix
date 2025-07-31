{
  home-manager,
  extraSpecialArgs,
  plasma-manager,
  zen-browser,
  nixcord,
  stylix,
  nixpkgs,
  specialArgs,
  system,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  inherit extraSpecialArgs;
  pkgs = import nixpkgs {
    inherit system;
    inherit (specialArgs) allowUnfreePredicate;
    overlays = specialArgs.extraOverlays;
  };
  modules = [
    plasma-manager.homeManagerModules.plasma-manager
    zen-browser.homeModules.zen-browser
    nixcord.homeModules.nixcord
    stylix.homeModules.stylix
    ./modules/home
  ];
}
