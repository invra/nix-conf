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
      utm
      tart
      pika
      steam
      raycast
      obs-studio
      linearmouse
      jankyborders
      alt-tab-macos
      betterdisplay
    ];

    file.".hushlogin".text = "";
  };
}
