{ system, ... }:
{
  system.defaults = {
    dock = {
      autohide = system.dock.autohide;
      orientation = system.dock.orientation;
      tilesize = 35;
      minimize-to-application = true;
      show-recents = false;
      wvous-br-corner = 1;
    };

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
      AppleMetricUnits = 1;
      _HIHideMenuBar = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      CreateDesktop = false;
      QuitMenuItem = true;
      NewWindowTarget = "Home";
    };

    screencapture = {
      location = "~/Desktop";
      type = "png";
      target = "clipboard";
    };

    loginwindow = {
      DisableConsoleAccess = true;
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      GloballyEnabled = false;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowSeconds = true;
    };
  };
}
