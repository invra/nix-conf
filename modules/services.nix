{
#   nixpkgs.allowedUnfreePackages = [
#     "mongodb"
#   ];
#   flake.modules = {
#     nixos.base = {
#       services = {
#         tailscale.enable = true;
#         flatpak.enable = true;
#         blueman.enable = true;
#         gvfs.enable = true;
#         qemuGuest.enable = true;
#         spice-vdagentd.enable = true;  
#         xserver = {
#           enable = true;
#           xkb = {
#             layout = "us,us";
#             options = "grp:alt_shift_toggle,caps:escape";
#             variant = ",workman";
#           };
#         };
#         fwupd.enable = true;
#         pipewire = {
#           enable = true;
#           alsa.enable = true;
#           pulse.enable = true;
#           jack.enable = true;
#         };

#         libinput.enable = true;
#         openssh.enable = true;
#         mongodb.enable = true;
#       };

#     };

#     darwin.base.services.tailscale.enable = true;
#   };
}
