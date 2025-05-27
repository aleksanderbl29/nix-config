{
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
    zsh-autosuggestions
    zsh-syntax-highlighting
    # pyenv
    pre-commit
    uv
    devenv
    # bruno
    # positron-bin
    figurine
    deadnix
    nixd
  ];

  programs = {
    home-manager.enable = true;
    lazygit.enable = true;

    bat.enable = true;
    htop.enable = true;

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };

  home.file = {
    ".Rprofile".source = ../dots/.Rprofile;
  };
}
