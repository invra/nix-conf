{ unstable, ... }:
let
  pkgs = unstable;
in
{
  stylix.targets = {
    nixcord.enable = false;
    vesktop.enable = false;
    vencord.enable = false;
  };

  programs.nixcord = {
    enable = true;
    discord = with pkgs; {
      enable = true;
      package = discord;
    };

    # vesktop = with pkgs; {
    #   enable = pkgs.stdenv.isLinux;
    #   package = vesktop;
    # };

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
        voiceMessages.enable = true;
        volumeBooster = {
          enable = true;
          multiplier = 5;
        };
        webRichPresence.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
