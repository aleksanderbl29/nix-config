{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    caskArgs = {
      appdir = "/Applications";
    };
    global.brewfile = true;
    masApps = {
      "AdGuard for Safari" = 1440147259;
      "Bitwarden" = 1352778147;
      "Disk Speed Test" = 425264550;
      "Flightly" = 1358823008;
      "Numbers" = 409203825;
      "Speedtest" = 1153157709;
      "Magnet" = 441258766;
      # "Trello" = 1278508951;
      # "Unsplash Wallpapers" = 1284863847;
    };
    casks = [
      "microsoft-office"
      "aldente"
      "alt-tab"
      # "balenaetcher"
      "bentobox"
      "busycal"
      "cyberduck"
      "dropbox"
      "element"
      "google-chrome"
      "ghostty"
      "home-assistant"
      "iterm2"
      "legcord"
      # "latest"
      # "lm-studio"
      "meetingbar"
      "microsoft-teams"
      "MonitorControl"
      "obs"
      "obsidian"
      # "orbstack"
      "pgadmin4"
      # "positron"
      "quarto"
      "r-app"
      # "raspberry-pi-imager"
      "raycast"
      "rstudio"
      "signal"
      "slack"
      # "sonos"
      # "spotify"
      # "spotify-notify"
      "stats"
      "synology-drive"
      # "telegram"
      # "transmission"
      "unnaturalscrollwheels"
      "vanilla"
      "visual-studio-code"
      "zotero"
      "zoom"
      "zen"
    ];
    brews = [
      "gcc"
      "btop"
      "cmatrix"
      "cowsay"
      "cryptography"
      "gh"
      "git"
      "graphviz"
      "helm"
      "imagemagick"
      "mas"
      "neofetch"
      "netcat"
      "nmap"
      "openjdk"
      "pandoc"
      "r"
      "starship"
      "tailscale"
      "tree"
    ];
  };
}
