{
  user,
  config,
  unstable,
  ...
}:
{
  home = {
    homeDirectory = "/Users/${user.username}";
    packages = with unstable; [
      jankyborders
      sketchybar
    ];

    file.".hushlogin".text = "";
  };

  local.dock = {
    enable = true;
    entries = [
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Zen.app"; }
      { path = "${unstable.zed-editor}/Applications/Zed.app"; }
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Vesktop.app"; }
      { path = "${unstable.vesktop}/Applications/Vesktop.app"; }
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Spotify.app"; }
    ];
  };
}
