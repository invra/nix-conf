{
  nixpkgs,
  pkgs,
  custils,
  ...
}:
let
  lib = nixpkgs.lib;
  stdenv = pkgs.stdenv;
in
{
  imports = custils.getModulesFromDirsRec (
    lib.lists.toList (lib.path.append ./. "󱄅")
    ++ (lib.optional stdenv.isLinux (lib.path.append ./. ""))
    ++ (lib.optional stdenv.isDarwin (lib.path.append ./. ""))
  );
}
