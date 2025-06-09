{
  lib,
  user,
  system,
  unstable,
  stable,
  desktop,
  ...
}:
let
  pkgs = unstable;
in
{
  imports = [
    ./options/defaults.nix
    ./options/envrionment.nix
    ./options/programs.nix
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  users.knownUsers = [ user.username ];

  users.users.${user.username} = {
    home = "/Users/${user.username}";
    uid = 501;
  };

  system = {
    # primaryUser = user.username;
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
