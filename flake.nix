{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
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
      system = "x86_64-linux";

      overlays = [ hyprpanel.overlay ];

      unstable = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgs = unstable;
      configTOML = (builtins.fromTOML (builtins.readFile ./config.toml));
      user = configTOML.user;
      development = configTOML.development;
      desktop = configTOML.desktop;
    in
    {
      nixosConfigurations.${user.username} = nixpkgs.lib.nixosSystem {
        inherit system;
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
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
