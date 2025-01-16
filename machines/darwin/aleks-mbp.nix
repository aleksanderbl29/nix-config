{ ... }:
let
  user = "aleksander";
in
{
  nix = {
    settings = {
      trusted-users = [ ${user} ];
    };
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = ${user};
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "gcenx/wine" = {
        url = "https://github.com/gcenx/homebrew-wine";
        flake = false;
      };
      "homebrew/services" = {
        url = "https://github.com/Homebrew/homebrew-services";
        flake = false;
      };
      "hudochenkov/sshpass" = {
        url = "https://github.com/hudochenkov/homebrew-sshpass";
        flake = false;
      };
      "teamookla/speedtest" = {
        url = "https://github.com/teamookla/homebrew-speedtest";
        flake = false;
      };
    };
  };

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
      "Disk Speed Test" = 425264550;
      "Fantastical" = 975937182;
      "Home Assistant" = 1099568401;
      "Numbers" = 409203825;
      "OpenSpeedTest-Server" = 1579499874;
      "QuickShade" = 931571202;
      "Speedtest" = 1153157709;
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
      "aldente"
      "alt-tab"
      "bentobox"
      "bitwarden"
      "cursor"
      "dropbox"
      "element"
      "iterm2"
      "obsidian"
      "orbstack"
      "pgadmin4"
      "quarto"
      "r"
      "raspberry-pi-imager"
      "raycast"
      "rstudio"
      "slack"
      "sonos"
      "spotify"
      "stats"
      "unnaturalscrollwheels"
      "vanilla"
      "visual-studio-code"
      "warp"
      "zotero"
      "zen-browser"
    ];
    brews = [
      "gcc"
      "btop"
      "cmatrix"
      "cowsay"
      "cryptography"
      "docker"
      "gh"
      "git"
      "graphviz"
      "helm"
      "imagemagick"
      "kompose"
      "kubernetes-cli"
      "mas"
      "minikube"
      "neofetch"
      "neovim"
      "netcat"
      "nmap"
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

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };
}