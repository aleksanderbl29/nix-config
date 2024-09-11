{ pkgs, ...}:
let
  user = "aleksanderbang-larsen";
  od_loc = "/Users/${ user }/Library/CloudStorage/OneDrive-AarhusUniversitet";
in
{
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    curl
    htop
    oh-my-posh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    pyenv
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
        renv-commit = "git add renv.lock && git commit -m 'Update renv snapshot'";
        ropen = "open *.Rproj";
        onedrive = "cd ${ od_loc }";
        g-drive = "cd '/Users/${ user }/Library/CloudStorage/GoogleDrive-aleksanderbl@live.dk/Mit drev/'";
        dropbox = "cd '/Users/${ user }/Library/CloudStorage/Dropbox'";
        us_pres_elec = "cd '${ od_loc }/7 - US Presidential Election/US_pres_elec'";
        pol_geo_ds = "cd '${ od_loc }/7 - Politisk geo-data-science med R/pol_geo_ds'";
        fu-commit = "git add flake.lock && git commit -m 'Update flake.lock'";
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