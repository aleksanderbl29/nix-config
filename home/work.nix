{
  pkgs,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./tmux.nix
  ];

  # Ghostty configuration
  home.file.".config/ghostty/config".source = ../dots/ghostty;

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

  programs.git = {
    enable = true;
    # userEmail = "github@aleksanderbl.dk";
    # userName = "aleksanderbl29";
    ignores = [ ".DS_Store" ];
    lfs.enable = true;
    diff-so-fancy.enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
    };
  };
}
