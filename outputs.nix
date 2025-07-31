{
  nixpkgs-stable,
  nixpkgs-24_11,
  flake-utils,
  darwin,
  nixpkgs,
  home-manager,
  plasma-manager,
  ip,
  nixcord,
  stylix,
  ghostty,
  zen-browser,
  ...
}:
(builtins.foldl' nixpkgs.lib.attrsets.recursiveUpdate { } (
  builtins.attrValues (
    builtins.mapAttrs (
      name: configTOML:
      let
        custils = import ./utils { inherit (nixpkgs) lib; };

        allowUnfreePredicate = import ./unfree_predicates.nix {inherit (nixpkgs) lib;};

        specialArgs = unstable: stable: {
          pkgs = unstable;
          inherit
            nixpkgs-24_11
            home-manager
            unstable
            stable
            nixpkgs-stable
            nixpkgs
            plasma-manager
            nixcord
            stylix
            zen-browser
            custils
            configTOML
            ;
        };

        pkgs-config = system: {
          inherit system overlays;
          config = { inherit allowUnfreePredicate; };
        };

        overlays = [
          ghostty.overlays.default
          zen-browser.overlay
          ip.overlay
        ];
      in
      {
        darwinConfigurations.${name} =
          let
            unstable = import nixpkgs (pkgs-config "aarch64-darwin");
            stable = import nixpkgs-stable (pkgs-config "aarch64-darwin");
          in
          darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = specialArgs unstable stable;
            modules = [
              ./modules/config
            ];
          };
      }
      // (flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" ] (
        system:
        let
          unstable = import nixpkgs (pkgs-config system);
          stable = import nixpkgs-stable (pkgs-config system);
        in
        with unstable;
        {
          legacyPackages.nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = specialArgs unstable stable;
            modules = [
              ./modules/config
              stylix.nixosModules.stylix
            ];
          };
          legacyPackages.homeConfigurations.${name} = home-manager.lib.homeManagerConfiguration {
            pkgs = unstable;
            extraSpecialArgs = (specialArgs unstable stable) // {
              pkgs = unstable;
              pkgs-24_11 = import nixpkgs-24_11 (pkgs-config system);
            };
            modules = [
              plasma-manager.homeManagerModules.plasma-manager
              zen-browser.homeModules.zen-browser
              nixcord.homeModules.nixcord
              stylix.homeModules.stylix
              ./modules/home
            ];
          };
          formatter = nixfmt-tree;

          devShells.default = unstable.mkShell {
            buildInputs = with pkgs; [
              # Rust tools
              cargo
              rustfmt
              rust-analyzer

              # Nix tools
              nixd
              nil

              # Zig tools
              zig
              zls

              # Swift
              swift
              swiftformat
            ];
          };
        }
      ))
    ) (builtins.mapAttrs (name: _: import ./configurations/${name}) (builtins.readDir ./configurations))
  )
))
