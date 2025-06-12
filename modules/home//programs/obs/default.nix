{ unstable, ... }:
{
  programs.obs-studio = {
    enable = true;

    plugins = with unstable.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };
}
