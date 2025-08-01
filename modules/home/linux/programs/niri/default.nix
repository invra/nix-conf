{ ... }:
{
  home.file.".config/niri/config.kdl" = {
    text = import ./config-kdl.nix;
  };
}
