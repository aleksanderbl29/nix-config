{ pkgs, ... }:
{
  imports = [
    ../modules/home/tex.nix
  ];

  home.packages = with pkgs; [
    # minikube
    # kubectl
    compose2nix
  ];

  tex.enable = false;

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
    '';
  };
}
