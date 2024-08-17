{ pkgs, ...}: {
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    curl
    htop
    oh-my-posh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  programs = {
    home-manager.enable = true;

    fzf.enable = true;
    fzf.enableZshIntegration = true;

    htop.enable = true;

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "powerlevel10k_lean";
      # useTheme = "robbyrussell";
    };

    git = {
      enable = true;
      userEmail = "github@aleksanderbl.dk";
      userName = "aleksanderbl29";
    };


    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ls = "ls --color=auto -F";
        nixswitch = "darwin-rebuild switch --flake ~/src/nix-mbp/";
        nix-cd = "cd ~/src/nix-mbp";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          # "zsh-autosuggestions"
          # "zsh-syntax-highlighting"
        ];
      };
    };
  };
}