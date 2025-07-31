{
  pkgs,
  configTOML,
  ...
}:
{
  imports = [
    ../../../modules/dock
  ];

  home = {
    homeDirectory = "/Users/${configTOML.user.username}";
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
    ];

    file.".hushlogin".text = "";
  };
}
