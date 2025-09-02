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
  }
  // lib.optionalAttrs (!linux) {
    knownUsers = lib.optionals (!linux) [ flakeConfig.user.username ];
  };
}
// lib.optionalAttrs (!linux) {
  system.primaryUser = user.username;
}
