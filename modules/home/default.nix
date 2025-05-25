{
  nixpkgs,
  unstable,
  utils,
  ...
}:
let
  lib = nixpkgs.lib;
  stdenv = unstable.stdenv;
in
{
  imports = utils.getModulesFromDirsRec (
    lib.lists.toList (lib.path.append ./. "󱄅")
    ++ (lib.optional stdenv.isLinux (lib.path.append ./. ""))
    ++ (lib.optional stdenv.isDarwin (lib.path.append ./. ""))
  );
}
