{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm.url = "github:wez/wezterm?dir=nix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "gitlab:InvraNet/zen-browser-flake";
  };

  outputs = inputs@{ nixpkgs-stable, nixpkgs, home-manager, spicetify-nix
    , ... }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = unstable;
      spicePkgs = spicetify-nix.legacyPackages.${system};
    in {
      nixosConfigurations.invra = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./config/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.invra =
                (import ./home/home.nix spicePkgs inputs);
              extraSpecialArgs = {
                inherit pkgs unstable stable;
                username = "invra";
              };
            };
          }
        ];
      };
      formatter.${system} = pkgs.nixfmt-classic;
    };
}
