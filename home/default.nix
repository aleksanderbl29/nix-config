{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    ./zsh.nix
    ./tmux.nix
  ];

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    curl
    htop
    # oh-my-posh
    # oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    # pyenv
    pre-commit
    uv
    # azure-cli
    devenv
    bruno
    positron-bin
    # alacritty
    # tex # This is defined above
    figurine
  ];

  programs = {
    home-manager.enable = true;
    lazygit.enable = true;

    bat.enable = true;
    htop.enable = true;

    direnv = {
      enable = true;
      silent = true;
    };
  };

  home.file = {
    ".Rprofile".source = ../dots/.Rprofile;
  };
}
