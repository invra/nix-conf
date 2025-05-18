{
  unstable,
  spicetify-nix,
  ...
}:
let
  spicePkgs = spicetify-nix.legacyPackages.${unstable.system};
in
{
  imports = [ spicetify-nix.homeManagerModules.default ];
  stylix.targets.spicetify.enable = false;
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.sleek;
    colorScheme = "RosePine";

    enabledExtensions = with spicePkgs.extensions; [
      powerBar
      beautifulLyrics
      volumePercentage
    ];
  };
}
