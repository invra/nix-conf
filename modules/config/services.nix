{
  lib,
  linux,
  flakeConfig,
  ...
}:
let
  inherit (flakeConfig) system desktop;
in
{
  services = {
    tailscale.enable = true;
  }
  // lib.optionalAttrs linux {
    flatpak.enable = true;
    blueman.enable = true;
    gvfs.enable = true;
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    xserver = {
      enable = true;
      videoDrivers = system.graphics.wanted;
    };

    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    libinput.enable = true;
    openssh.enable = true;
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          securityType = "user";
          "workgroup" = "IDALON";
          "server string" = "Main SMB";
          "netbios name" = "smbnix";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "private" = {
          "path" = "/srv/smb";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "invra";
          "force group" = "wheel";
        };
      };
    };

    mongodb = {
      enable = true;
      # user = "mongo";
    };
  };
}
