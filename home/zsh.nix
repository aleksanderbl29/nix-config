{ ... }: {
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "powerlevel10k_lean";
      # useTheme = "robbyrussell";
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        # Basic
        ls = "ls --color=auto -F";

        # Nix specifics
        nixswitch = "darwin-rebuild switch --flake ~/src/nix-mbp/";
        nix-cd = "cd ~/src/nix-mbp";
        fu-commit = "nix flake update && git add flake.lock && git commit -m 'Update flake.lock'";
        open_nix = "nix-cd && code .";

        # R specific
        renv-commit = "git add renv.lock && git commit -m 'Update renv snapshot'";
        test-snapshot-update = ''
          git add tests/testthat/_snaps/ && git commit -m "Update test snapshots $(date '+%d %b %Y')"
        '';
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
      };
    };
  };
}