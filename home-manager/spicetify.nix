spicePkgs: inputs:
{ ... }: {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.sleek;
    colorScheme = "RosePine";

    enabledExtensions = with spicePkgs.extensions; [
      powerBar
      seekSong
      beautifulLyrics
      volumeProfiles
      volumePercentage
    ];
  };
}
