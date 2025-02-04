{ pkgs, ... }: {

  # Remove login message from shell
  home.file.".hushlogin".text = "";

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      # useTheme = "powerlevel10k_lean";
      # useTheme = "robbyrussell";
      settings = builtins.fromJSON (builtins.readFile ../dots/oh-my-posh/config.json);
    };


    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      loginExtra = ''
        if [[ -o interactive ]]; then
          ${pkgs.figurine}/bin/figurine -f "smslant.flf" "''${HOST%%.local}"
        fi
      '';

      shellAliases = {
        # Basic
        ls = "ls --color=auto -F";

        # Nix specifics
        nixswitch = if pkgs.stdenv.isDarwin
          then "darwin-rebuild switch --flake ~/nix-config/"
          else "sudo nixos-rebuild switch --flake ~/nix-config/";
        nix-cd = "cd ~/nix-config/";
        nix-gc = "nix-collect-garbage -d";
        nxp = "nix-shell -p";
        fu-commit = "nix flake update && git add flake.lock && git commit -m 'Update flake.lock'";
        open-nix = "nix-cd && code .";
	nix-nvim = "nix-cd && nvim .";

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
