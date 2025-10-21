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

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
    '';
  };
}
