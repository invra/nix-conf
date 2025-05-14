{
  nixpkgs,
  unstable,
  user,
  ...
}:
let
  utils = import ./utils.nix { lib = nixpkgs.lib; };
  lib = nixpkgs.lib;
  stdenv = unstable.stdenv;
in
{
  imports = utils.getModulesFromDirsRec (
            lib.lists.toList( lib.paths.append (./modules/home "󱄅"))
            ++ lib.optionals stdenv.isLinux lib.paths.append (./modules/home "")
            ++ lib.optional stdenv.isDarwin lib.paths.append (./modules/home ""));
}
