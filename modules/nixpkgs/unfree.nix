{ lib, config, ... }:
{
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.singleLineStr;
    default = [ ];
  };

  config = {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) [
        "bitwig-studio-unwrapped"
      ];

    flake.meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;
  };
}
