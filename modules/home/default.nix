{
  nixpkgs,
  nixpkgs-24_11,
  unstable,
  custils,
  ...
}:
let
  lib = nixpkgs.lib;
  pkgs-24_11 = nixpkgs-24_11;
  pkgs = unstable;
  stdenv = pkgs.stdenv;
in
{
  imports = custils.getModulesFromDirsRec (
    lib.lists.toList (lib.path.append ./. "󱄅")
    ++ (lib.optional stdenv.isLinux (lib.path.append ./. ""))
    ++ (lib.optional stdenv.isDarwin (lib.path.append ./. ""))
  );
}
