{
  pkgs,
  configTOML,
  ...
}:
{
  imports = [
    ./options/envrionment.nix
    ./options/programs.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  users.knownUsers = [ configTOML.user.username ];

  users.users.${configTOML.user.username} = {
    home = "/Users/${configTOML.user.username}";
    uid = 501;
  };

  system = with configTOML; {
    primaryUser = user.username;
    keyboard = {
      enableKeyMapping = true;
      swapLeftCommandAndLeftAlt = system.normaliseKbd or false;
      swapLeftCtrlAndFn = system.normaliseKbd or false;
    };
    startup.chime = true;
    stateVersion = 6;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
