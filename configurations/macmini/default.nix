{
  desktop = {
    plasma = {
      enable = true;
    };
  };
  development = {
    git = {
      defaultBranch = "main";
      email = "identificationsucks@gmail.com";
      types = [
        "GitLab"
        "GitHub"
      ];
      username = "InvraNet";
    };
  };
  system = {
    dock = {
      autoHideDelay = 0.45;
      autohide = true;
      orientation = "bottom";
      entries = {pkgs, ...}: [
          { path = "/Applications/Apps.app"; }
          { path = "/System/Applications/Mail.app"; }
          { path = "/System/Applications/Music.app"; }
          { path = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
          { path = "${pkgs.zen}/Applications/Zen.app"; }
      ];
    };
    hostname = "NixOS";
  };
  user = {
    displayName = "peter";
    initialPassword = "123456";
    username = "peter";
  };
}
