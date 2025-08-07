{
  flakeConfig,
  ...
}:
let
  inherit (flakeConfig) user;
in
{
  users.users.${user.username} = {
    inherit (user) initialPassword;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "libvirtd"
      "audio"
    ];
  };
}
