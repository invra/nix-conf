{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-24_11.url = "github:NixOS/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "gitlab:InvraNet/zen-flake";
    nixcord.url = "git+https://github.com/kaylorben/nixcord?rev=caca900dcbfcd6ca2d60a1a49f53853c0ed60e5f";
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
    (builtins.foldl' nixpkgs.lib.attrsets.recursiveUpdate { } (
      builtins.attrValues (
        builtins.mapAttrs (
          name: configTOML:
          let
            overlays = [
              zen-browser.overlay
              ghostty.overlays.default
              ip.overlay
            ];

            custils = import ./utils { inherit (nixpkgs) lib; };

            user = configTOML.user;
            development = configTOML.development;
            desktop = configTOML.desktop;

            allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "davinci-resolve"
                "steam-unwrapped"
                "steam_osx"
                "discord"
                "tart"
                "betterdisplay"
                "raycast"
                "steam"
                "bitwig-studio-unwrapped"
                "parsec-bin"
                "mongodb-compass"
                "postman"
                "teams"
                "nvidia-x11"
                "nvidia-settings"
              ];
          in
          {
            darwinConfigurations.${name} =
              let
                unstable = import nixpkgs {
                  inherit overlays;
                  system = "aarch64-darwin";
                  config = { inherit allowUnfreePredicate; };
                };
                stable = import nixpkgs-stable {
                  inherit overlays;
                  system = "aarch64-darwin";
                  config = { inherit allowUnfreePredicate; };
                };

              in
              darwin.lib.darwinSystem {
                system = "aarch64-darwin";
                specialArgs = {
                  inherit
                    desktop
                    user
                    home-manager
                    development
                    unstable
                    stable
                    nixpkgs-stable
                    nixpkgs
                    plasma-manager
                    nixcord
                    stylix
                    zen-browser
                    custils
                    ;
                  system = configTOML.system;
                  username = user.username;
                };
                modules = [
                  ./modules/config
                ];
              };
          }
          // (flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" ] (
            system:
            let
              unstable = import nixpkgs {
                inherit system overlays;
                config = { inherit allowUnfreePredicate; };
              };
              stable = import nixpkgs-stable {
                inherit system overlays;
                config = { inherit allowUnfreePredicate; };
              };
              inherit (configTOML) user;
            in
            with unstable;
            {
              legacyPackages.nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {
                  inherit
                    desktop
                    user
                    home-manager
                    development
                    unstable
                    stable
                    nixpkgs-stable
                    nixpkgs
                    plasma-manager
                    nixcord
                    stylix
                    zen-browser
                    custils
                    ;
                  inherit (configTOML) system;
                  inherit (user) username;
                };
                modules = [
                  ./modules/config
                  stylix.nixosModules.stylix
                ];
              };
              formatter = nixfmt-tree;
              legacyPackages.homeConfigurations.${name} = home-manager.lib.homeManagerConfiguration {
                pkgs = unstable;
                extraSpecialArgs = {
                  inherit
                    desktop
                    user
                    home-manager
                    unstable
                    stable
                    nixpkgs-24_11
                    nixpkgs-stable
                    nixpkgs
                    plasma-manager
                    nixcord
                    stylix
                    zen-browser
                    custils
                    ;
                  pkgs = unstable;
                  pkgs-24_11 = import nixpkgs-24_11 { inherit system; };
                  inherit (configTOML) system development;
                  inherit (user) username;
                };
                modules = [
                  plasma-manager.homeManagerModules.plasma-manager
                  nixcord.homeModules.nixcord
                  stylix.homeModules.stylix
                  ./modules/home
                ];
              };
            }
          ))
        ) (builtins.mapAttrs (name: _: import ./configurations/${name}) (builtins.readDir ./configurations))
      )
    ))
    // {
      custils = import ./utils { inherit (nixpkgs) lib; };
    };
}
