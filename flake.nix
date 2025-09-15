{
  nixConfig.extra-experimental-features = [ "pipe-operators" ];

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
    treefmt-nix.url = "github:numtide/treefmt-nix";
    sketchierbar.url = "gitlab:invra/sketchierbar";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/a53af7f1514ef4cce8620a9d6a50f238cdedec8b";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixcord = {
      url = "github:KaylorBen/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-utils, nixpkgs, ... }@flakeInputs:
    let
      inherit (nixpkgs) lib;

      mkConfigs =
        configs:
        let
          mkOne =
            name: flakeConfig:
            let
              system =
                if lib.strings.hasSuffix "x86" name then
                  "x86_64-linux"
                else if lib.strings.hasSuffix "aarch64" name then
                  "aarch64-linux"
                else
                  "aarch64-darwin";

              pkgs = import nixpkgs { inherit system; };

              custils = import ./utils {
                inherit (nixpkgs) lib;
                inherit pkgs flakeInputs flakeConfig;
                configName = name;
              };
            in
            with custils.builders;
            {
              nixosConfigurations.${name} = mkNixConfig system;
              homeConfigurations.${name} = mkHomeConfig system;
              darwinConfigurations.${name} = mkDarwinConfig system;
            };
        in
        builtins.foldl' lib.attrsets.recursiveUpdate { } (builtins.attrValues (lib.mapAttrs mkOne configs));

    in
    let
      devShellsAll = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          custils = import ./utils {
            inherit (nixpkgs) lib;
            inherit pkgs flakeInputs;
            flakeConfig = { };
            configName = "devshell";
          };
        in
        {
          packages = custils.development.packages;
          formatter = custils.development.formatter;
          devShells.default = custils.development.devShell;
        }
      );
    in
    {
      mkConfigs = mkConfigs;
    }
    // devShellsAll;
}
