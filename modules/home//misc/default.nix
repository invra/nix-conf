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
      { path = "${unstable.zen}/Applications/Zen.app"; }
      { path = "${unstable.zed-editor}/Applications/Zed.app"; }
      { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Discord.app"; }
      { path = "${unstable.wezterm}/Applications/WezTerm.app"; }
    ];
  };
}
