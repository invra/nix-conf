{
  config,
  system,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/wallpaper
    ../../modules/dock
  ];

  targets.darwin = {
    dock = {
      enable = true;
    } // pkgs.lib.optionalAttrs (system ? dock && system.dock ? entries) {
      entries = system.dock.entries { inherit pkgs config; };
    };
    
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        AppleICUForce24HourTime = true;
        "com.apple.keyboard.fnState" = true;
        AppleTemperatureUnit = "Celsius";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = true;
        AppleHighlightColor = "0.968627 0.831373 1.000000 Purple";
        AppleAccentColor = 5;
      };

      "com.apple.screencapture" = {
        location = "~/Desktop";
        type = "png";
        target = "clipboard";
      };

      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = false;
        GloballyEnabled = false;
      };

      "com.apple.menuextra.clock" = {
        Show24Hour = true;
        ShowSeconds = true;
      };

      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.finder" = {
        AppleShowAllExtensions = true;
        CreateDesktop = false;
        QuitMenuItem = true;
        NewWindowTarget = "Home";
      };

      "com.apple.dock" = {
        autohide = system.dock.autohide or false;
        orientation = system.dock.orientation or "bottom";
        tilesize = system.dock.size or 64;
        minimize-to-application = true;
        show-recents = false;
        wvous-br-corner = 1;
        size-immutable = true;
      };
    };
  };

  programs.setWallpaper = {
    enable = true;
    wallpaperPath = ../../../../wallpapers/landscape.jpg;
  };
}
