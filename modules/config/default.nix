{
  linux,
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

  system.stateVersion = if linux then "25.11" else 6;
}

