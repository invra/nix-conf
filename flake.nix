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
    discord-rpc-lsp.url = "gitlab:invra/discord-rpc-lsp"; 
    
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
      flake-utils,
      nixpkgs,
      ...
    }@flakeInputs:
    let
      inherit (nixpkgs) lib;
    in
    (builtins.foldl' lib.attrsets.recursiveUpdate { } (
      builtins.attrValues (
        builtins.mapAttrs (
          name: configTOML:
          let
            configure = import ./utils/configuration {
              inherit (nixpkgs) lib;
              inherit flakeInputs configTOML;
              configName = name;
            };
            system =
              if lib.strings.hasSuffix "x86" name then
                "x86_64-linux"
              else if lib.strings.hasSuffix "aarch64" name then
                "aarch64-linux"
              else
                "aarch64-darwin";
          in
          {
            nixosConfigurations.${name} = configure.mkNixConfig system;
            homeConfigurations.${name} = configure.mkHomeConfig system;
            darwinConfigurations.${name} = configure.mkDarwinConfig system;
          }
        ) (builtins.mapAttrs (name: _: import ./configurations/${name}) (builtins.readDir ./configurations))
      )
    ))
    // (flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      devShells.default = import ./devsh.nix (import nixpkgs { inherit system; });
    }));
}
