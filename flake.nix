{
  description = "aleksanders flake";
  inputs = {
  # Where we get most of our software. Giant mono repo with recipes
  # called derivations that say how to build software.
  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

  # Manages configs links things into your home directory
  home-manager.url = "github:nix-community/home-manager/master";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  # Controls system level software and settings including fonts
  darwin.url = "github:lnl7/nix-darwin";
  darwin.inputs.nixpkgs.follows = "nixpkgs";

  # Tricked out nvim
  # pwnvim.url = "github:zmre/pwnvim";
  };
  outputs = inputs: {
    darwinConfigurations.Aleksanders-MacBook-Pro =
      inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
        modules = [
          ({ pkgs, ... }: {
            users.users.aleksanderbang-larsen.home = "/Users/aleksanderbang-larsen";
            programs.zsh.enable = true;
            environment.shells = [ pkgs.bash pkgs.zsh ];
            environment.loginShell = pkgs.zsh;
            environment.systemPackages = [ pkgs.coreutils ];
            environment.systemPath = [ "/opt/homebrew/bin" ];
            environment.pathsToLink = [ "/Applications" ];
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToControl = true;
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
              "com.apple.mouse.tapBehavior" = 1;
              ApplePressAndHoldEnabled = false;
            };
            system.stateVersion = 4;
            homebrew = {
              enable = true;
              caskArgs.no_quarantine = true;
              global.brewfile = true;
              masApps = {
                "2048 Game" = 871033113;
                "AdGuard for Safari" = 1440147259;
                "Be Focused" = 973134470;
                "Bitwarden" = 1352778147;
                "Disk Speed Test" = 425264550;
                "Fantastical" = 975937182;
                "Flappy Golf 2" = 1154174205;
                "Home Assistant" = 1099568401;
                "Hop" = 1092825540;
                "Magnet" = 441258766;
                "Microsoft Remote Desktop" = 1295203466;
                "Numbers" = 409203825;
                "Octagon" = 691956219;
                "OpenSpeedTest-Server" = 1579499874;
                "QuickShade" = 931571202;
                "Speedtest" = 1153157709;
                # "Sudoku" = 1489692148;
                # "Sudoku 9x9" = 903089432;
                "Super Stickman Golf 3" = 1071253172;
                "Tailscale" = 1475387142;
                "Telegram" = 747648890;
                "Trello" = 1278508951;
                "Unsplash Wallpapers" = 1284863847;
                "WhatsApp" = 1147396723;
                "WireGuard" = 1451685025;
              };
              taps =
              [
                "gcenx/wine"
                "homebrew/bundle"
                "homebrew/services"
                "hudochenkov/sshpass"
                "teamookla/speedtest"
              ];
              casks =
              [
                "microsoft-office"
                "arc"
                "fantastical"
                "messenger"
                "alacritty"
                "alt-tab"
                "amethyst"
                "balenaetcher"
                "element"
                # "font-meslo-lg-nerd-font"
                "geekbench"
                "imageoptim"
                "iterm2"
                "latest"
                "lm-studio"
                "obsidian"
                "orbstack"
                "pgadmin4"
                "postman"
                "quarto"
                "r"
                "raspberry-pi-imager"
                "raycast"
                "rstudio"
                "slack"
                "sonos"
                "spotify"
                "stats"
                "tad"
                "transmission"
                "unnaturalscrollwheels"
                "vanilla"
                "visual-studio-code"
                "vlc"
                "warp"
                # "xquartz"
                "zotero"
                "utm"
              ];
              brews =
              [
                "azure-cli"
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
                "node"
                "openjdk"
                "pandoc"
                # "r", link: false
                "starship"
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
            system.defaults.dock = {
              autohide = false;
              expose-group-by-app = true;
              magnification = true;
              largesize = 78;
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
              tilesize = 72;
              wvous-bl-corner = 5;
              wvous-br-corner = 14;
              wvous-tl-corner = 1;
              wvous-tr-corner = 1;
            };
          })
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.aleksanderbang-larsen.imports = [
                ({ pkgs, ...}: {
                  home.stateVersion = "22.11";
                  home.packages = [
                    pkgs.curl
                    pkgs.htop
                  ];
                  programs = {
                    home-manager.enable = true;
                    fzf.enable = true;
                    fzf.enableZshIntegration = true;
                    git = {
                      enable = true;
                      userEmail = "github@aleksanderbl.dk";
                      userName = "aleksanderbl29";
                    };
                    zsh = {
                      enable = true;
                      enableCompletion = true;
                      enableAutosuggestions = true;
                      enableSyntaxHighlighting = true;
                      shellAliases = { ls = "ls --color=auto -F"; };
                      # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                    };
                  };
                })
              ];
            };
          }
        ];
      };
  };
}