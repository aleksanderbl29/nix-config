{
  ...
}: {
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXPreferredViewStyle = "clmv";
    ShowPathbar = true;
  };

  system.defaults = {
    loginwindow.LoginwindowText = ''
    Velkommen til Aleksanders Mac


    '';
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 10;
    };
    trackpad.Clicking = true;
  };


  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    AppleInterfaceStyleSwitchesAutomatically = true;
    AppleShowScrollBars = "Automatic";
    InitialKeyRepeat = 15;
    KeyRepeat = 1;
    NSNavPanelExpandedStateForSaveMode = true;
    # "com.apple.mouse.tapBehavior" = 1;
    ApplePressAndHoldEnabled = false;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf";      # When performing a search, search the current folder by default
    };

    "com.apple.desktopservices" = {
      # Avoid creating .DS_Store files on network or USB volumes
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    "com.apple.SoftwareUpdate" = {
      AutomaticCheckEnabled = true;
      # Check for software updates daily, not just once per week
      ScheduleFrequency = 1;
      # Download newly available updates in background
      AutomaticDownload = 1;
      # Install System data files & security updates
      CriticalUpdateInstall = 1;
    };

    "com.apple.commerce".AutoUpdate = true;          # Turn on app auto-update
    "com.apple.diskmanagement".DiskEject = false;    # Turn off disk eject warning

  };
}