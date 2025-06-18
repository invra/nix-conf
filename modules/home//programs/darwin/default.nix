{
  config,
  system,
  unstable,
  ...
}:
let
  pkgs = unstable;
in
{
  targets.darwin.defaults = {
    "com.apple.dock" = {
      autohide = system.dock.autohide;
      orientation = system.dock.orientation;
      tilesize = 40;
      minimize-to-application = true;
      show-recents = false;
      wvous-br-corner = 1;
      size-immutable = true;
    };
  };

  local.dock = {
    enable = true;
    entries = [
      { path = "/Applications/Launchpad.app"; }
      { path = "${pkgs.zen}/Applications/Zen.app"; }
      { path = "${pkgs.zed-editor}/Applications/Zed.app"; }
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Discord.app"; }
      { path = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
    ];
  };
}
