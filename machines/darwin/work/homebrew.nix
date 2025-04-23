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
      # "AdGuard for Safari" = 1440147259;
      # "Bitwarden" = 1352778147;
    };
    casks = [
      # "microsoft-office"
      # "microsoft-teams"
      "fantastical"
      # "aldente"
      "alt-tab"
      # "bentobox"
      "google-chrome"
      "ghostty"
      # "lm-studio"
      "meetingbar"
      # "MonitorControl"
      # "obsidian"
      # "orbstack"
      "raycast"
      "stats"
      "unnaturalscrollwheels"
      "vanilla"
      "visual-studio-code"
      "zen-browser"
    ];
    brews = [
      "gcc"
      "btop"
      "cmatrix"
      "cowsay"
      "gh"
      "git"
      "mas"
      "neofetch"
      "nmap"
      #"tmux"
      "tree"
    ];
  };
}
