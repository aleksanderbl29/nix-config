{ ... }: {
  programs ≈ {
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
        ropen = "open *.Rproj";
        posit = "open -a 'Positron' .";
        test-snapshot-update = ''
          git add tests/testthat/_snaps/ && git commit -m "Update test snapshots $(date '+%d %b %Y')"
        '';

        # Folder navigation
        onedrive = "cd ${ od_loc }";
        g-drive = "cd '${ cloud_stor }/GoogleDrive-aleksanderbl@live.dk/Mit drev/'";
        dropbox = "cd '${ cloud_stor }/Dropbox'";
        us_pres_elec = "cd '${ od_loc }/7 - US Presidential Election/US_pres_elec'";
        pol_geo_ds = "cd '${ od_loc }/7 - Politisk geo-data-science med R/pol_geo_ds'";
        t7 = "cd '/Volumes/T7 Shield/developer'";
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