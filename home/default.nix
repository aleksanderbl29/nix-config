{ config, pkgs, ...}:
let
  user = "aleksanderbang-larsen";
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      dvisvgm dvipng wrapfig amsmath ulem hyperref capt-of
      titling framed inconsolata collection-fontsrecommended;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
in
{
  imports = [
    ./git.nix
    ./zsh.nix
  ];

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    curl
    htop
    oh-my-posh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    pyenv
    pre-commit
    uv
    azure-cli
    devenv
    bruno
    # positron-bin
    # alacritty
    # tex # This is defined above
    # devenv
    nodejs_20
  ];

  programs = {
    home-manager.enable = true;

    htop.enable = true;
  };

  home.file = {
    ".Rprofile".source = ../dots/.Rprofile;
  };

}