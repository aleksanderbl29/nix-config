{
  pkgs,
  ...
}: {
  imports = [
    ./homebrew.nix
  ];
  users.users.aleksanderbang-larsen.home = "/Users/aleksanderbang-larsen";
  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  # system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  services.nix-daemon.enable = true;
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXPreferredViewStyle = "clmv";
    ShowPathbar = true;
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
  system.defaults.trackpad.Clicking = true;
  system.stateVersion = 4;
  system.defaults.dock = {
    autohide = false;
    expose-group-by-app = true;
    magnification = true;
    mru-spaces = false;
    orientation = "bottom";
    persistent-apps =
    [
      "/Applications/Arc.app"
      "/Applications/Fantastical.app"
      "/Applications/Spotify.app"
      "/System/Applications/Messages.app"
      "/Applications/Messenger.app"
      "/Applications/Microsoft Outlook.app"
      "/System/Applications/Preview.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/RStudio.app"
      "/Applications/Obsidian.app"
      "/Applications/Iterm.app"
      "/Applications/Zotero.app"
      "/System/Applications/System Settings.app"
    ];
    persistent-others =
    [
      "/Users/aleksanderbang-larsen/Downloads"
    ];
    show-recents = false;
    show-process-indicators = true;
    # tilesize = 64;
    # tilesize = 72;
    tilesize = 68;
    # largesize = 78;
    largesize = 74;
    wvous-bl-corner = 5;
    wvous-br-corner = 14;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
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
    "com.apple.screensaver" = {
      # Ask for pswd 60 seconds after screensaver starts
      askForPassword = 1;
      askForPasswordDelay = 60;
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
    "com.apple.symbolichotkeys" = {                  # Found on reddit https://www.reddit.com/r/NixOS/comments/17n3tcn/setting_keyboard_shortcuts_in_nix_darwin/
      AppleSymbolicHotKeys = {
        "64" = {
          enabled = false;
        };
      };
    };
  };
}