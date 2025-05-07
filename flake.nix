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
      spicetify-nix,
      nixcord,
      stylix,
      neovim-nightly-overlay,
      zen-browser,
      ...
    }:
    let
      overlays = [ hyprpanel.overlay ];
      configTOML = (builtins.fromTOML (builtins.readFile ./config.toml));

      unstable = import nixpkgs {
        inherit overlays;
        system = configTOML.system.arch;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit overlays;
        system = configTOML.system.arch;
        config.allowUnfree = true;
      };
      pkgs = unstable;
      user = configTOML.user;
      development = configTOML.development;
      desktop = configTOML.desktop;
    in
    {
      nixosConfigurations.${user.username} = nixpkgs.lib.nixosSystem {
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
            stylix
            neovim-nightly-overlay
            zen-browser
            ;
          system = configTOML.system;
          username = user.username;
        };
        modules = [
          ./modules/config
          ./modules/home
          stylix.nixosModules.stylix
        ];
      };
      darwinConfigurations.${user.username} = darwin.lib.darwinSystem {
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
            stylix
            neovim-nightly-overlay
            zen-browser
            ;
          system = configTOML.system;
          username = user.username;
        };
        modules = [
          ./modules/nix-darwin/config
          ./modules/nix-darwin/home
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: with import nixpkgs { inherit system; }; {
        formatter = nixfmt-tree;
      }
    );
}
