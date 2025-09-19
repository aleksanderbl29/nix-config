{ pkgs, ... }:
{
  # Remove login message from shell
  home.file.".hushlogin".text = "";

  home.packages = with pkgs; [
    zsh
    fzf
    zoxide
  ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--color=auto"
      ];
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
        # Git
        lzg = "lazygit";

        # Nix specifics
        nixswitch =
          if pkgs.stdenv.isDarwin then
            "sudo darwin-rebuild switch --flake ~/nix-config/"
          else
            "sudo nixos-rebuild switch --flake /etc/nixos/";
        nix-cd = if pkgs.stdenv.isDarwin then "cd ~/nix-config/" else "cd /etc/nixos/";
        nix-gc = ''
          sudo nix-env -p /nix/var/nix/profiles/system --list-generations
          sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old
          sudo nix-collect-garbage -d
          nix-collect-garbage -d
        '';
        nxp = "nix-shell -p";
        fu-commit = "nix flake update && git add flake.lock && git commit -m 'Update flake.lock'";
        open-nix = "nix-cd && code .";
        nix-nvim = "nix-cd && nvim .";

        # cd shortcuts
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        # File system shortcuts
        pwdcopy = "pwd | pbcopy";

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
