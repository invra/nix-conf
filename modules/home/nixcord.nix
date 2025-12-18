{
  pkgs,
  ...
}:
{
  programs.nixcord = {
    enable = true;
    discord = {
      enable = !(pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64);
      vencord.enable = false;
      equicord.enable = true;
    };
    vesktop.enable = (pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64);

    config = {
      useQuickCss = true;
      themeLinks = [ ];
      frameless = false;
      plugins = {
        iLoveSpam.enable = true;
        betterSettings.enable = true;
        crashHandler.enable = true;
        fixSpotifyEmbeds = {
          enable = true;
          volume = 9.0;
        };
        fixYoutubeEmbeds.enable = true;
        imageZoom.enable = true;
        noF1.enable = true;
        onePingPerDm.enable = true;
        openInApp.enable = true;
        quickReply.enable = true;
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
          multiplier = 2.0;
        };
        messageClickActions = {
          enable = true;
          enableDoubleClickToEdit = true;
        };
        webRichPresence.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
