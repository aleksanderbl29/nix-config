{
  ...
}: {
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
      # "2048 Game" = 871033113;
      "AdGuard for Safari" = 1440147259;
      # "Be Focused" = 973134470;
      # "Bitwarden" = 1352778147;
      "Disk Speed Test" = 425264550;
      "Fantastical" = 975937182;
      # "Flappy Golf 2" = 1154174205;
      "Home Assistant" = 1099568401;
      # "Hop" = 1092825540;
      # "Magnet" = 441258766;
      # "Microsoft Remote Desktop" = 1295203466;
      "Numbers" = 409203825;
      # "Octagon" = 691956219;
      "OpenSpeedTest-Server" = 1579499874;
      "QuickShade" = 931571202;
      "Speedtest" = 1153157709;
      # "Sudoku" = 1489692148;
      # "Sudoku 9x9" = 903089432;
      # "Super Stickman Golf 3" = 1071253172;
      # "Tailscale" = 1475387142;
      # "Telegram" = 747648890;
      # "Trello" = 1278508951;
      # "Unsplash Wallpapers" = 1284863847;
      "WireGuard" = 1451685025;
    };
    taps = [
      "gcenx/wine"
      "homebrew/bundle"
      "homebrew/services"
      "hudochenkov/sshpass"
      "teamookla/speedtest"
    ];
    casks = [
      "microsoft-office"
      "font-latin-modern"
      "font-latin-modern-math"
      # "arc"
      # "fantastical"
      # "messenger"
      "aldente"
      "alt-tab"
      # "amethyst"
      # "balenaetcher"
      "bentobox"
      "bitwarden"
      "dropbox"
      "element"
      # "font-meslo-lg-nerd-font"
      # "geekbench"
      # "imageoptim"
      "iterm2"
      # "latest"
      # "lm-studio"
      "obsidian"
      "orbstack"
      "pgadmin4"
			# "positron"
      # "postman"
      "quarto"
      "r"
      "raspberry-pi-imager"
      "raycast"
      "rstudio"
      "slack"
      "sonos"
      "spotify"
      "stats"
      # "tad"
      # "transmission"
      "unnaturalscrollwheels"
      "vanilla"
      "visual-studio-code"
      # "vlc"
      "warp"
      # "whatsapp"
      # "xquartz"
      "zotero"
      "zen-browser"
      # "utm"
    ];
    brews = [
      "gcc"
      "btop"
      "cmatrix"
      "cowsay"
      "cryptography"
      "docker"
      # "gdal"
      "gh"
      "git"
      "graphviz"
      "helm"
      # "htop"
      "imagemagick"
      "kompose"
      "kubernetes-cli"
      "mas"
      "minikube"
      "neofetch"
      "neovim"
      "netcat"
      "nmap"
      # "node"
      "openjdk"
      "pandoc"
      "starship"
      "tailscale"
      "tere"
      "tmux"
      "tree"
      "vim"
      "wimlib"
      "wireguard-tools"
      "hudochenkov/sshpass/sshpass"
      "teamookla/speedtest/speedtest"
    ];
  };
}
