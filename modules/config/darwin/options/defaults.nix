{ system, ... }:
{
  system.defaults = {
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

    # "NSGlobalDomain" = {
    #   AppleHighlightColor = "0.968627 0.831373 1.000000 Purple";
    #   AppleAccentColor = 5;
    # };
  };
}
