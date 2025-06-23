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
imports = [
  ../../../modules/wallpaper
  ../../../modules/dock
];
    
  targets.darwin.defaults = {
    "com.apple.dock" = {
      autohide = system.dock.autohide or false;
      orientation = system.dock.orientation or "bottom";
      tilesize = system.dock.size or 64;
      minimize-to-application = true;
      show-recents = false;
      wvous-br-corner = 1;
      size-immutable = true;
    };
  };

  local.dock = {
    enable = true;
    entries = (system.dock.entries or ({ ... }: [
      { path = "/Applications/Launchpad.app"; }
      { path = "/Applications/Safari.app"; }
      { path = "/System/Applications/Messages.app"; }
      { path = "/System/Applications/Mail.app"; }
      { path = "/System/Applications/Maps.app"; }
      { path = "/System/Applications/Photos.app"; }
      { path = "/System/Applications/FaceTime.app"; }
      { path = "/System/Applications/Calendar.app"; }
      { path = "/System/Applications/Contacts.app"; }
      { path = "/System/Applications/Reminders.app"; }
      { path = "/System/Applications/Notes.app"; }
      { path = "/System/Applications/Freeform.app"; }
      { path = "/System/Applications/TV.app"; }
      { path = "/System/Applications/Music.app"; }
      { path = "/System/Applications/News.app"; }
      { path = "/System/Applications/System Settings.app"; }
    ])) {inherit pkgs config;};
  };
    programs.setWallpaper = {
      enable = true;
      wallpaperPath = ../../../../../wallpapers/landscape.jpg;
    };
}
