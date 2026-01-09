{
  nixpkgs.allowedUnfreePackages = [
    "mongodb"
  ];
  flake.modules = {
    nixos.base = {
      services = {
        tailscale.enable = true;
        blueman.enable = true;
        gvfs.enable = true;
        qemuGuest.enable = true;
        spice-vdagentd.enable = true;
        xserver = {
          enable = true;
          xkb = {
            layout = "us,us";
            options = "grp:alt_shift_toggle,caps:escape";
            variant = ",workman";
          };
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
        mongodb.enable = true;
      };
      networking.firewall = {
        enable = false;
        allowedTCPPorts = [
          22
          80
          443
          8080
        ];
      };
    };

    darwin.base.services.tailscale.enable = true;
  };
}
