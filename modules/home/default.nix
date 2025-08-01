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
    lib.lists.toList ./common
    ++ (lib.optional linux ./linux)
    ++ (lib.optional (!linux) ./darwin)
  );
  nixpkgs = {
    config.allowUnfreePredicate = allowUnfreePredicate;
    overlays = extraOverlays;
  };
}
