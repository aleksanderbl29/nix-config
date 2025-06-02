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
      "Magnet" = 441258766;
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
      "obsidian"
      # "orbstack"
      "raycast"
      "signal"
      "stats"
      "unnaturalscrollwheels"
      "vanilla"
      "visual-studio-code"
      "zen"
      "zoho-cliq"
      "zoho-mail"
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
      "tree"
    ];
  };
}
