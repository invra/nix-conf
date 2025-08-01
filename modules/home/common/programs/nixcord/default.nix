{
  pkgs,
  ...
}:
{
  stylix.targets = {
    nixcord.enable = false;
    vencord.enable = false;
  };

  programs.nixcord = {
    enable = true;
    discord.enable = true;
    quickCss = import ./quickcss.nix;

    config = {
      useQuickCss = true;
      themeLinks = [ ];
      frameless = false;
      plugins = {
        betterSettings.enable = true;
        callTimer.enable = true;
        crashHandler.enable = true;
        fixSpotifyEmbeds = {
          enable = true;
          volume = 9.0;
        };
        fixYoutubeEmbeds.enable = true;
        imageZoom.enable = true;
        noF1.enable = true;
        onePingPerDM.enable = true;
        openInApp.enable = true;
        quickReply.enable = true;
        spotifyControls.enable = true;
        spotifyCrack.enable = true;
        spotifyShareCommands.enable = true;
        voiceChatDoubleClick.enable = true;
        voiceDownload.enable = true;
        voiceMessages = {
          enable = true;
          echoCancellation = false;
          noiseSuppression = false;
        };
        volumeBooster = {
          enable = true;
          multiplier = 2;
        };
        webRichPresence.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
