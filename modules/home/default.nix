{
  custils,
  lib,
  linux,
  allowUnfreePredicate,
  extraOverlays,
  ...
}:
{
  imports = custils.getModulesFromDirsRec (
    lib.lists.toList (lib.path.append ./. "󱄅")
    ++ (lib.optional linux (lib.path.append ./. ""))
    ++ (lib.optional (!linux) (lib.path.append ./. ""))
  );
  nixpkgs = {
    config.allowUnfreePredicate = allowUnfreePredicate;
    overlays = extraOverlays;
  };
}
