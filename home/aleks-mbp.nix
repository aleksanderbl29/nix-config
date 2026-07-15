{ pkgs, ... }:
{
  imports = [
    ../modules/tex.nix
  ];

  home.packages = with pkgs; [
    # minikube
    # kubectl
    compose2nix
    # supersonic currently fails to link on aarch64-darwin with nixpkgs-unstable.
    # Re-enable once the package builds again.
    # supersonic
    bruno
    # positron-bin
  ];

  tex.enable = false;

  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yy";
    };
  };

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
      RSTUDIO_WHICH_R=/opt/homebrew/bin/R
    '';
  };

  home.file.".hammerspoon" = {
    source = ../dots/hammerspoon;
    recursive = true;
  };
}
