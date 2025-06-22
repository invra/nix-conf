{
  user,
  config,
  unstable,
  ...
}:
{
  imports = [
    ../../../modules/dock
  ];

  home = {
    homeDirectory = "/Users/${user.username}";
    packages = with unstable; [
      jankyborders
      sketchybar
      alt-tab-macos
      raycast
      blender
      linearmouse
      obs-studio
      steam
      betterdisplay
      pika
      tart
      utm
      teams
    ];

    file.".hushlogin".text = "";
  };
}
