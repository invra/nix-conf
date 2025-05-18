{
  unstable,
  user,
  system,
  ...
}:

{
  environment.systemPackages = with unstable; [
    btop
    git
    jq
    nil
    nodejs
    cargo
    lua
    ripgrep
    nushell
    zed-editor
    switchaudio-osx
    nowplaying-cli
  ];

  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
  system.stateVersion = 4;
  security.pam.services.sudo_local.touchIdAuth = true;
  environment.shells = [
    unstable.bashInteractive
    unstable.zsh
    unstable.fish
    unstable.nushell
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  users.knownUsers = [ user.username ];
  users.users.${user.username} = {
    name = user.username;
    home = "/Users/${user.username}";
    uid = 501;
    shell = unstable.nushell;
  };

  system = {
    defaults = {
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

    keyboard = {
      enableKeyMapping = true;
      swapLeftCommandAndLeftAlt = true;
      swapLeftCtrlAndFn = true;
    };

    startup.chime = true;
  };

  homebrew = {
    enable = true;

    casks = [
      "tailscale"
      "pika"
      "steam"
      "roblox"
      "alt-tab"
      "utm"
      "linearmouse"
      "raycast"
      "betterdisplay"
    ];
  };
}
