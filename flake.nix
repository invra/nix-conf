{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    stylix.url = "github:danth/stylix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "gitlab:InvraNet/zen-flake";
    ghostty.url = "gitlab:Hiten-Tandon/ghostty-darwin";
    nixcord.url = "github:kaylorben/nixcord";
    ip.url = "gitlab:hiten-tandon/ghostty-darwin";
    wezterm.url = "github:wez/wezterm?dir=nix";

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
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
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
      hyprpanel,
      ip,
      wezterm,
      nixcord,
      stylix,
      neovim-nightly-overlay,
      zen-browser,
      ...
    }:
    (builtins.foldl' nixpkgs.lib.attrsets.recursiveUpdate { } (
      builtins.attrValues (
        builtins.mapAttrs (
          name: configTOML:
          let
            overlays = [
              hyprpanel.overlay
              zen-browser.overlay
              ip.overlay
            ];

            user = configTOML.user;
            development = configTOML.development;
            desktop = configTOML.desktop;
          in
          {
            nixosConfigurations.${name} =
              let
                unstable = import nixpkgs {
                  inherit overlays;
                  system = "x86_64-linux";
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (nixpkgs.lib.getName pkg) [
                      "spotify"
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
                  inherit overlays;
                  system = "x86_64-linux";
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (nixpkgs.lib.getName pkg) [
                      "spotify"
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
              in
              nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";

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
                    hyprpanel
                    nixcord
                    stylix
                    neovim-nightly-overlay
                    zen-browser
                    ;
                  system = configTOML.system;
                  username = user.username;

                };
                modules = [
                  ./modules/config
                  stylix.nixosModules.stylix
                ];
              };
            darwinConfigurations.${name} =
              let
                unstable = import nixpkgs {
                  inherit overlays;
                  system = "aarch64-darwin";
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (nixpkgs.lib.getName pkg) [
                      "spotify"
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
                  system = "x86_64-linux";
                  config.allowUnfreePredicate =
                    pkg:
                    builtins.elem (nixpkgs.lib.getName pkg) [
                      "spotify"
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
                    hyprpanel
                    nixcord
                    stylix
                    neovim-nightly-overlay
                    zen-browser
                    ;
                  system = configTOML.system;
                  username = user.username;
                };
                modules = [
                  ./modules/config
                ];
              };
          }
          // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" ] (
            system:
            let
              overlays = [
                hyprpanel.overlay
                zen-browser.overlay
                (_:s:{
                  wezterm = wezterm.outputs.packages.${s.system}.default;
                })
                ip.overlay
              ];
              unstable = import nixpkgs {
                inherit system overlays;
                config.allowUnfreePredicate =
                  pkg:
                  builtins.elem (nixpkgs.lib.getName pkg) [
                    "spotify"
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
                    "spotify"
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
              user = configTOML.user;
            in
            with unstable;
            {
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
                    hyprpanel
                    nixcord
                    stylix
                    neovim-nightly-overlay
                    zen-browser
                    ;
                  pkgs = unstable;
                  system = configTOML.system;
                  development = configTOML.development;
                  username = user.username;
                };
                modules = [
                  plasma-manager.homeManagerModules.plasma-manager
                  nixcord.homeModules.nixcord
                  stylix.homeModules.stylix
                  ./modules/home
                ];
              };
            }
          )
        ) (builtins.mapAttrs (name: _: import ./configurations/${name}) (builtins.readDir ./configurations))
      )
    ));
}
