{ unstable, ... }:
{
  users.users.${user.username} = {
    inherit (user) initialPassword;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "libvirtd"
    ];
    packages = with unstable; [
      wayvnc
      wget
      jdk21
      glib
      libreoffice-qt-fresh
      remmina
      gcc
      clang-tools
      cmake
      calibre
      gnumake
    ];
  };
}
