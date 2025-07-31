{
  nixpkgs,
  system ? "x86_64-linux",
  specialArgs ? { },
  stylix,
  ...
}:
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  modules = [
    ./modules/config
    stylix.nixosModules.stylix
  ];
}
