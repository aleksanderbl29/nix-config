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
      # "Trello" = 1278508951;
      # "Unsplash Wallpapers" = 1284863847;
    };
    casks = [
      "microsoft-office"
      # "arc"
      "fantastical"
      "messenger"
      "aldente"
      "alt-tab"
      # "balenaetcher"
      "bentobox"
      "dropbox"
      "element"
      "google-chrome"
      "ghostty"
      "home-assistant"
      "iterm2"
      # "latest"
      # "lm-studio"
      "meetingbar"
      "microsoft-teams"
      "MonitorControl"
      "obsidian"
      "orbstack"
      "pgadmin4"
      # "positron"
      # "postman"
      "quarto"
      "r"
      # "raspberry-pi-imager"
      "raycast"
      "rstudio"
      "slack"
      "sonos"
      # "spotify"
      # "spotify-notify"
      "stats"
      "super-productivity"
      "synology-drive"
      # "telegram"
      # "transmission"
      "unnaturalscrollwheels"
      "vanilla"
      "visual-studio-code"
      "warp"
      # "whatsapp"
      "zotero"
      "zoom"
      "zen-browser"
      # "utm"
    ];
    brews = [
      "gcc"
      "btop"
      "cmatrix"
      "cowsay"
      "cryptography"
      # "gdal"
      "gh"
      "git"
      "graphviz"
      "helm"
      # "htop"
      "imagemagick"
      "mas"
      "neofetch"
      # "neovim"
      "netcat"
      "nmap"
      # "node"
      "openjdk"
      "pandoc"
      "starship"
      "tailscale"
      "tere"
      #"tmux"
      "tree"
      # "vim"
      "wimlib"
      "wireguard-tools"
      "hudochenkov/sshpass/sshpass"
      "teamookla/speedtest/speedtest"
    ];
  };
}
