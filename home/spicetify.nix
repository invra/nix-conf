spicePkgs: pkgs: inputs:
{ ... }: {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.sleek;
    colorScheme = "RosePine";

    enabledExtensions = with spicePkgs.extensions; [
      powerBar
      beautifulLyrics
      volumePercentage
      ({
        src = pkgs.fetchFromGitHub {
          owner = "notPlancha";
          repo = "volume-profiles-v2";
          rev = "v2.2.0";
          hash = "sha256-gbG/OnIPR/okeYgN8RDn9gwbQVISdnbdQe1fqfgkc6o=";
        };
        name = "dist/volume-profiles.js";
      })
    ];
  };
}
