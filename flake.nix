{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "gitlab:InvraNet/zen-flake";
    ghostty.url = "gitlab:Hiten-Tandon/ghostty-darwin";
    nixcord.url = "github:kaylorben/nixcord";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      ghostty,
      spicetify-nix,
      nixcord,
      nixvim,
      stylix,
      neovim-nightly-overlay,
      zen-browser,
      ...
    }:
    let
      overlays = [
        hyprpanel.overlay
        (super: _: { zen = zen-browser.outputs.packages.${super.system}.default; })
      ];
      configTOML = (builtins.fromTOML (builtins.readFile ./config.toml));

      user = configTOML.user;
      development = configTOML.development;
      desktop = configTOML.desktop;
    in
    {
      nixosConfigurations.${user.username} =
        let
          unstable = import nixpkgs {
            inherit overlays;
            system = "x86_64-linux";
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "spotify"
                "steam-unwrapped"
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
                "steam-unwrapped"
                "steam"
                "parsec-bin"
                "mongodb-compass"
                "postman"
              ];
          };
          pkgs = unstable;
        in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit
              desktop
              user
              pkgs
              home-manager
              development
              unstable
              stable
              nixpkgs-stable
              nixpkgs
              plasma-manager
              hyprpanel
              spicetify-nix
              nixcord
              nixvim
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
      darwinConfigurations.${user.username} =
        let
          unstable = import nixpkgs {
            inherit overlays;
            system = "aarch64-darwin";
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "spotify"
                "steam-unwrapped"
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
                "steam-unwrapped"
                "steam"
                "parsec-bin"
                "mongodb-compass"
                "postman"
              ];
          };
          pkgs = unstable;

        in
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit
              desktop
              user
              pkgs
              home-manager
              development
              unstable
              stable
              nixpkgs-stable
              nixpkgs
              plasma-manager
              hyprpanel
              spicetify-nix
              nixcord
              nixvim
              stylix
              neovim-nightly-overlay
              zen-browser
              ;
            system = configTOML.system;
            username = user.username;
          };
          modules = [
            ./modules/nix-darwin/config
          ];
        };
    }
    // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" ] (
      system:
      let
        overlays = [
          hyprpanel.overlay
          # ghostty.overlay
          (super: _: { zen = zen-browser.outputs.packages.${super.system}.default; })
        ];
        unstable = import nixpkgs {
          inherit system overlays;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "spotify"
              "steam-unwrapped"
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
              "steam-unwrapped"
              "steam"
              "parsec-bin"
              "mongodb-compass"
              "postman"
            ];
        };
        pkgs = unstable;
        configTOML = builtins.fromTOML (builtins.readFile ./config.toml);
        user = configTOML.user;
      in
      with pkgs;
      {
        formatter = nixfmt-tree;
        legacyPackages.homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              desktop
              user
              pkgs
              home-manager
              unstable
              stable
              nixpkgs-stable
              nixpkgs
              plasma-manager
              hyprpanel
              spicetify-nix
              nixcord
              nixvim
              ghostty
              stylix
              neovim-nightly-overlay
              zen-browser
              ;
            system = configTOML.system;
            development = configTOML.development;
            username = user.username;
          };
          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            nixcord.homeModules.nixcord
            nixvim.homeManagerModules.nixvim
            stylix.homeModules.stylix
            ./modules/home
          ];
        };
      }
    );
}
