{
  user,
  config,
  ghostty,
  unstable,
  ...
}:
{
  home = {
    homeDirectory = "/Users/${user.username}";
    packages = with unstable; [
      jankyborders
      ghostty
      alacritty
      sketchybar
    ];

    file.".hushlogin".text = "";
  };

  local.dock = {
    enable = true;
    entries = [
      { path = "/Applications/Zen.app"; }
      { path = "${unstable.zed-editor}/Applications/Zed.app"; }
      { path = "/Applications/Ghostty.app"; }
      { path = "${unstable.vesktop}/Applications/Vesktop.app"; }
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Spotify.app"; }
    ];
  };
}
