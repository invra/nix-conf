{
  lib,
  pkgs,
  flakeInputs,
  flakeConfig,
  configName,
  ...
}:
let
  getModulesFromDirRec = import ./lib/getModulesFromDirRec.nix { inherit lib; };

  specialArgs = {
    inherit (flakeInputs)
      nixpkgs-24_11
      home-manager
      nixpkgs-stable
      plasma-manager
      nixcord
      stylix
      zen-browser
      ;
    inherit flakeConfig;
    extraOverlays = with flakeInputs; [
      discord-rpc-lsp.overlays.default
      sketchierbar.overlays.default
      ghostty.overlays.default
      zen-browser.overlay
      ip.overlay
    ];
    linux = (lib.strings.hasSuffix "x86" configName || lib.strings.hasSuffix "aarch64" configName);
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "davinci-resolve"
        "steam-unwrapped"
        "steam_osx"
        "steam"
        "bitwig-studio-unwrapped"
        "discord"
      ];
    custils = import ./. {
      inherit
        lib
        pkgs
        flakeInputs
        flakeConfig
        configName
        ;
    };
  };

  mkHomeConfig =
    system:
    import ./configuration/configure-home.nix {
      inherit (flakeInputs)
        home-manager
        plasma-manager
        nixcord
        stylix
        zen-browser
        nixpkgs
        ;
      inherit system;
      extraSpecialArgs = specialArgs;
    };

  mkDarwinConfig =
    _:
    import ./configuration/configure-darwin.nix {
      inherit (flakeInputs)
        darwin
        stylix
        ;
      inherit specialArgs;
    };
  mkNixConfig =
    system:
    import ./configuration/configure-nixos.nix {
      inherit (flakeInputs)
        nixpkgs
        stylix
        ;
      inherit specialArgs system;
    };

in
{
  lib = {
    inherit getModulesFromDirRec;
  };

  builders = {
    inherit mkHomeConfig mkDarwinConfig mkNixConfig;
  };

  development = {
    devShell = pkgs.callPackage ./dev/devsh.nix { };
    formatter = pkgs.callPackage ./dev/formatter.nix { inherit flakeInputs; };
  };
}
