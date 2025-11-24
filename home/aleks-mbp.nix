{ pkgs, ... }:
{
  imports = [
    ../modules/tex.nix
  ];

  home.packages = with pkgs; [
    # minikube
    # kubectl
    compose2nix
    supersonic
    bruno
    # positron-bin
  ];

  tex.enable = false;

  programs = {
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
    '';
  };
}
