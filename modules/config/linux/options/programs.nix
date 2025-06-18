{ unstable, ... }:
let
  pkgs = unstable;
in
{
  programs = {
    nix-ld.enable = true;
    # steam = {
    #   enable = true;
    #   remotePlay.openFirewall = true;
    #   dedicatedServer.openFirewall = true;
    #   localNetworkGameTransfers.openFirewall = true;
    # };
    virt-manager.enable = true;
    dconf.enable = true;
    thunar.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    ghostty-bin
    # firefox-esr
    home-manager
  ];
}
