{ unstable, ... }:
{
  environment.systemPackages = with unstable; [
    nodejs
    cargo
    lua
    nushell
    tailscale
    switchaudio-osx
    nowplaying-cli
  ];

  programs = {
    zsh.enable = true;
  };
}
