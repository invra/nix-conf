{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    stylix.url = "github:danth/stylix";
    zen-browser.url = "gitlab:InvraNet/zen-flake";
    nixcord.url = "github:kaylorben/nixcord";
    ip.url = "gitlab:hiten-tandon/some-nix-darwin-packages";

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
      flake-utils,
      darwin,
      nixpkgs,
      home-manager,
      plasma-manager,
      ip,
      nixcord,
      stylix,
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
              ip.overlay
            ];

            custils = import ./utils { inherit (nixpkgs) lib; };

            user = configTOML.user;
            development = configTOML.development;
            desktop = configTOML.desktop;
          in
          {
            darwinConfigurations.${name} =
              let
                unstable = import nixpkgs {
                  inherit overlays;
                  system = "aarch64-darwin";
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (nixpkgs.lib.getName pkg) [
                      "davinci-resolve"
                      "steam-unwrapped"
                      "steam"
                      "steam_osx"
                      "discord"
                      "betterdisplay"
                      "raycast"
                      "parsec-bin"
                      "mongodb-compass"
                      "postman"
                    ];
                };
                stable = import nixpkgs-stable {
                  inherit overlays;
                  system = "aarch64-darwin";
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (nixpkgs.lib.getName pkg) [
                      "davinci-resolve"
                      "steam-unwrapped"
                      "steam_osx"
                      "discord"
                      "betterdisplay"
                      "raycast"
                      "steam"
                      "parsec-bin"
                      "mongodb-compass"
                      "postman"
                    ];
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
              overlays = [
                zen-browser.overlay
                ip.overlay
              ];
              unstable = import nixpkgs {
                inherit system overlays;
                config.allowUnfreePredicate =
                  pkg:
                  builtins.elem (nixpkgs.lib.getName pkg) [
                    "davinci-resolve"
                    "steam-unwrapped"
                    "steam_osx"
                    "discord"
                    "betterdisplay"
                    "raycast"
                    "steam"
                    "parsec-bin"
                    "mongodb-compass"
                    "postman"
                  ];
              };
              stable = import nixpkgs-stable {
                inherit system overlays;
                config.allowUnfreePredicate =
                  pkg:
                  builtins.elem (nixpkgs.lib.getName pkg) [
                    "davinci-resolve"
                    "steam-unwrapped"
                    "steam_osx"
                    "discord"
                    "betterdisplay"
                    "raycast"
                    "steam"
                    "parsec-bin"
                    "mongodb-compass"
                    "postman"
                  ];
              };
              inherit (configTOML) user;
            in
            with unstable;
            {
              legacyPackages.nixosConfigurations.${name} =
                (nixpkgs.lib.attrsets.filterAttrsRecursive (_: v: v != null)
                (nixpkgs.lib.attrsets.recursiveUpdate 
                (nixpkgs.lib.attrsets.optionalAttrs (!unstable.stdenv.isDarwin) nixpkgs.lib.nixosSystem
                  {
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
                  }) (nixpkgs.lib.attrsets.optionalAttrs (stdenv.isAarch64 && stdenv.isLinux) {
                    options.hardware.graphics = {
                      enable32Bit = null;
                      package32 = null;
                    };
                  })));
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
                    nixpkgs-stable
                    nixpkgs
                    plasma-manager
                    nixcord
                    stylix
                    zen-browser
                    custils
                    ;
                  pkgs = unstable;
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
