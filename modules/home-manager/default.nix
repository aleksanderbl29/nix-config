{ pkgs, ...}: {
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    curl
    htop
  ];
  programs = {
    home-manager.enable = true;

    fzf.enable = true;
    fzf.enableZshIntegration = true;

    htop.enable = true;

    git = {
      enable = true;
      userEmail = "github@aleksanderbl.dk";
      userName = "aleksanderbl29";
    };

    # imports = [
    #   ../../programs/zsh
    # ];

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        ls = "ls --color=auto -F";
        nixswitch = "darwin-rebuild switch --flake ~/src/nix-mbp/";
      };
      # shellAliases = { ls = "ls --color=auto"; };
      # promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };
  };
}