{
  custils,
  extraOverlays,
  allowUnfreePredicate,
  ...
}:
{
  imports = (custils.getModulesFromDirRec ./. true);

  nixpkgs = {
    config.allowUnfreePredicate = allowUnfreePredicate;
    overlays = extraOverlays;
  };
}

