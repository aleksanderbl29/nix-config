{ pkgs, lib, ... }:
{
  system.defaults.dock = lib.mkForce {
    autohide = false;
    expose-group-apps = true;
    magnification = true;
    mru-spaces = false;
    orientation = "bottom";
    persistent-apps = [
      "/Applications/Zen.app"
      "/Applications/Fantastical.app"
      "${pkgs.spotify}/Applications/Spotify.app"
      "/System/Applications/Messages.app"
      "/Applications/Zoho Mail - Desktop.app"
      "/System/Applications/Preview.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Obsidian.app"
      "/Applications/Ghostty.app"
      "/System/Applications/System Settings.app"
    ];
    persistent-others = [
      "/Users/aleksander/Downloads"
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
}
