{ nixpkgs, ... }:
let
  utils = import ./utils.nix { inherit (nixpkgs) lib; };
in
{
  import = utils.getModulesFromDirsRec [
    ./misc
    ./programs
  ];
}
