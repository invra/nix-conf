{
  pkgs,
  ...
}:
{
  programs = {
    nix-ld.enable = true;
    steam = {
      enable = pkgs.stdenv.isx86_64;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    virt-manager.enable = true;
    dconf.enable = true;
    thunar.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    zen
    pciutils
    xwayland-satellite
    swww
  ];
}
