{ unstable, ... }:
{
  environment.systemPackages = with unstable; [
    nodejs
    cargo
    lua
    nushell
    switchaudio-osx
    nowplaying-cli
  ];

  programs = {
    zsh.enable = true;
  };

  homebrew = {
    enable = true;

    casks = [
      "tailscale"
      "pika"
      "steam"
      "roblox"
      "alt-tab"
      "utm"
      "linearmouse"
      "raycast"
      "betterdisplay"
    ];
  };
}
