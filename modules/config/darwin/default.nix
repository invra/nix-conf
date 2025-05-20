{
  lib,
  user,
  system,
  unstable,
  stable,
  desktop,
  ...
}:
{
  imports = [
    ./options/defaults.nix
    ./options/envrionment.nix
    ./options/programs.nix
  ];

  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";
  security.pam.services.sudo_local.touchIdAuth = true;
  users.knownUsers = [ user.username ];
  users.users.${user.username} = {
    home = "/Users/${user.username}";
    uid = 501;
  };

  system = {
    primaryUser = user.username;
    keyboard = {
      enableKeyMapping = true;
      swapLeftCommandAndLeftAlt = true;
      swapLeftCtrlAndFn = true;
    };
    startup.chime = true;
  };
}
