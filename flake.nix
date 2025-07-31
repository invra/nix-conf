{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-24_11.url = "github:NixOS/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "gitlab:invra/zen-flake";
    ip.url = "gitlab:hiten-tandon/some-nix-darwin-packages";
    ghostty.url = "github:ghostty-org/ghostty";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
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
    let
      inherit (nixpkgs) lib;
    in
    (builtins.foldl' lib.attrsets.recursiveUpdate { } (
      builtins.attrValues (
        builtins.mapAttrs (
          name: configTOML:
          let
            specialArgs = {
              inherit
                nixpkgs-24_11
                home-manager
                nixpkgs-stable
                plasma-manager
                nixcord
                stylix
                zen-browser
                configTOML
                ;
              extraOverlays = [
                zen-browser.overlay
                ghostty.overlays.default
                ip.overlay
              ];
              linux = (lib.strings.hasSuffix "x86" name || lib.strings.hasSuffix "aarch64" name);
              allowUnfreePredicate =
                pkg:
                builtins.readFile ./unfreePacakges.txt |> builtins.split "\n" |> builtins.elem (lib.getName pkg);
            };

          in
          {
            homeConfigurations.${name} = import ./configure-home.nix {
              inherit
                home-manager
                plasma-manager
                nixcord
                stylix
                zen-browser
                ;
              extraSpecialArgs = specialArgs;
            };
          }
          // lib.optionalAttrs (!lib.strings.hasSuffix "x86" name && !lib.strings.hasSuffix "aarch64" name) {
            darwinConfigurations.${name} = import ./configure-darwin.nix { inherit darwin specialArgs; };
          }
          // lib.optionalAttrs (lib.strings.hasSuffix "x86" name) {
            nixosConfigurations.${name} = import ./configure-nixos.nix {
              inherit
                nixpkgs
                stylix
                specialArgs
                ;
              system = "x86_64-linux";
            };
          }
          // lib.optionalAttrs (lib.strings.hasSuffix "aarch64" name) {
            nixosConfigurations.${name} = import ./configure-nixos.nix {
              inherit
                nixpkgs
                stylix
                specialArgs
                ;
              system = "aarch64-linux";
            };
          }

        ) (builtins.mapAttrs (name: _: import ./configurations/${name}) (builtins.readDir ./configurations))
      )
    ))
    // (flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      devShells.default = import ./devsh.nix { pkgs = import nixpkgs { inherit system; }; };
    }));
}
