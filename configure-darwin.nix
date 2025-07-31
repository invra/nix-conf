{ darwin, specialArgs, ... }:
darwin.lib.darwinSystem {
  inherit specialArgs;
  system = "aarch64-darwin";
  modules = [ ./modules/config ];
}
