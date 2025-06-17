{ unstable, ... }:
{
  environment.systemPackages = with unstable; [
    tailscale
  ];

  programs = {
    zsh.enable = true;
  };
}
