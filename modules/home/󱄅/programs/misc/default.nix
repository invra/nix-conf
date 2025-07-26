{ pkgs, ... }:
let
  fetchFirefoxAddon =
    {
      name,
      addonId,
      url,
      sha256,
    }:
    pkgs.stdenv.mkDerivation {
      name = "${name}-${addonId}";
      src = pkgs.fetchurl { inherit url sha256; };
      preferLocalBuild = true;
      allowSubstitutes = true;
      buildCommand = ''
        cp $src $out
        chmod 644 $out
      '';
    };
  # Define custom extensions from AMO
  ublock-origin = fetchFirefoxAddon {
    name = "ublock-origin";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4271569/ublock_origin-1.58.0-an+fx.xpi";
    sha256 = "g58EyZGTyt9XzAPPHrA+nd8tXwQ5o8pb0nJHBhl56pY=";
  };
  bitwarden = fetchFirefoxAddon {
    name = "bitwarden";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4276504/bitwarden_password_manager-2024.7.1-an+fx.xpi";
    sha256 = "YoOHbmabod2n1qV2IXbTHtPVxSJsFG5AGiEPP/R/A3U=";
  };
in
{
  home.packages = with pkgs; [
    postman
    parsec-bin
    pgadmin4-desktopmode
    viu
    chromium
    ffmpeg
    file
    fd
    tree
    unzip
    nil
    nixd
    yt-dlp
    tldr
    yazi
    remmina
  ];

  programs.zen-browser = {
    enable = true;
    package = pkgs.zen;
    profileName = "personal";
    extraConfig = ''
      user_pref("browser.startup.homepage", "https://start.duckduckgo.com");
      user_pref("browser.newtabpage.enabled", false);
      user_pref("general.smoothScroll", true);
    '';
    profiles = {
      personal = {
        name = "personal";
        settings = {
          "browser.startup.homepage" = "https://start.duckduckgo.com";
          "browser.toolbars.bookmarks.visibility" = "never";
          "privacy.trackingprotection.enabled" = true;
        };
        extensions = [ ublock-origin ];
      };
      work = {
        name = "work";
        settings = {
          "browser.startup.homepage" = "https://mail.google.com";
          "browser.download.dir" = "~/work-downloads";
          "signon.rememberSignons" = false;
        };
        extensions = [ bitwarden ];
      };
      "pnsd0143.Default (release)" = {
        dontCreate = true;
      };
    };
  };
}
