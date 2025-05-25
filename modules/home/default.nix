{
  nixpkgs,
  unstable,
  custils,
  ...
}:
let
  lib = nixpkgs.lib;
  stdenv = unstable.stdenv;
in
{
  imports = custils.getModulesFromDirsRec (
    lib.lists.toList (lib.path.append ./. "󱄅")
    ++ (lib.optional stdenv.isLinux (lib.path.append ./. ""))
    ++ (lib.optional stdenv.isDarwin (lib.path.append ./. ""))
  );
}
