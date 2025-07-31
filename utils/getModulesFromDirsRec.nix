{ lib, ... }@inputs:
let
  getModulesFromDirRec = import ./getModulesFromDirRec.nix inputs;
  getModulesFromDirsRec =
    dirs: lib.lists.unique (lib.lists.flatten (builtins.map getModulesFromDirRec dirs));
in
getModulesFromDirsRec
