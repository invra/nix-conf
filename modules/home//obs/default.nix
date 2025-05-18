{ unstable, ... }:
{
  programs.obs-studio = {
    enable = true;

    plugins = with unstable.obs-studio-plugins; [
      obs-websocket
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
