{
  pkgs,
  ...
}:
let
  inherit (pkgs) lib stdenv;
  custils = import ../utils { inherit lib; };
in
{
  imports = custils.getModulesFromDirsRec (
    lib.lists.toList (lib.path.append ./. "󱄅")
    ++ (lib.optional stdenv.isLinux (lib.path.append ./. ""))
    ++ (lib.optional stdenv.isDarwin (lib.path.append ./. ""))
  );
}
