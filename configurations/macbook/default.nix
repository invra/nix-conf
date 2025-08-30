{
  development.scm = {
    mercurial = {
      enable = true;
      defaultBranch = "main";
      email = "identificationsucks@gmail.com";
      username = "Invra";
    };
    git = {
      defaultBranch = "main";
      email = "identificationsucks@gmail.com";
      username = "Invra";
    };
    types = [
      "GitLab"
      "GitHub"
    ];
  }; 
  system = {
    keyboard = {
      normalise = true;
      remapCapsToEscape = true;
    };
    dock = {
      autoHideDelay = 0.45;
      autohide = true;
      orientation = "right";
      size = 40;
      entries =
        {
          pkgs,
          config ? { },
        }:
        [
          { path = "/System/Applications/Apps.app"; }
          { path = "${pkgs.zen}/Applications/Zen.app"; }
          { path = "${config.home.homeDirectory}/Applications/Home Manager Apps/Discord.app"; }
          { path = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
        ];
    };
    hostname = "NixOS";
    timezone = "Australia/Sydney";
  };
  user = {
    displayName = "Invra";
    initialPassword = "123456";
    username = "invra";
  };
}
