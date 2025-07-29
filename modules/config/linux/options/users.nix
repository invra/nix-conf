{
  configTOML,
  ...
}:
{
  users.users.${configTOML.user.username} = {
    inherit (configTOML.user) initialPassword;
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
