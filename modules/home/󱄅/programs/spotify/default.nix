{ ... }:
{
  stylix.targets.spotify-player.enable = false;

  home.file.".config/spotify-player/theme.toml".source = ./theme.toml;

  programs.spotify-player = {
    enable = true;

    settings = {
      theme = "rose-pine";
      notify_format = {
        summary = "{track}";
        body = "{artists} - {album}";
      };
      playback_refresh_duration_in_ms = 500;

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