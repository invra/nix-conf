{
  user,
  unstable,
  ...
}:
let pkgs = unstable; in
{
  imports = [
    ../../../modules/dock
  ];

  home = {
    homeDirectory = "/Users/${user.username}";
    packages = with pkgs; [
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
