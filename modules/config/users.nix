{
  lib,
  pkgs,
  linux,
  flakeConfig,
  ...
}:
let
  inherit (flakeConfig) user;
in
{
  users = {
    knownUsers = lib.mkIf (!linux) [ flakeConfig.user.username ];
    users.${user.username} = {
      name = user.username;
      description = user.displayName;
      shell = pkgs.nushell;
    }
    // lib.optionalAttrs linux {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "docker"
        "wheel"
        "libvirtd"
        "audio"
      ];
    }
    // lib.optionalAttrs (!linux) {
      home = "/Users/${flakeConfig.user.username}";
      uid = 501;
    };
  };
  system.primaryUser = user.username;
}
