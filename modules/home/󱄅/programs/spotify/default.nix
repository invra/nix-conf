{ ... }:
{
  stylix.targets.spotify-player.enable = true;

  programs.spotify-player = {
    enable = true;

    settings = {
      device = {
        volume = 40;
        bitrate = 320;
      };
      layout = {
        playback_window_position = "Bottom";
        library = {
          playlist_percent = 60;
          album_percent = 20;
        };
      };
    };
  };
}