{
  flakeInputs,
  configName,
  configTOML,
  lib,
  ...
}:
let
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
    inherit configTOML;
    extraOverlays = with flakeInputs; [
      zen-browser.overlay
      ghostty.overlays.default
      ip.overlay
    ];
    linux = (lib.strings.hasSuffix "x86" configName || lib.strings.hasSuffix "aarch64" configName);
    allowUnfreePredicate =
      pkg:
      builtins.readFile ../../unfreePacakges.txt |> builtins.split "\n" |> builtins.elem (lib.getName pkg);
    custils = import ../. { inherit lib; };
  };
in
{

  mkHomeConfig =
    system:
    import ./configure-home.nix {
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
    import ./configure-darwin.nix {
      inherit (flakeInputs) darwin;
      inherit specialArgs;
    };
  mkNixConfig =
    system:
    import ./configure-nixos.nix {
      inherit (flakeInputs)
        nixpkgs
        stylix
        ;
      inherit specialArgs system;
    };
}
