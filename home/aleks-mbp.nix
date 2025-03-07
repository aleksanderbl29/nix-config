{ pkgs, ... }:
{
  imports = [
    ./tex.nix
  ];

  home.packages = with pkgs; [
    # minikube
    # kubectl
    ollama
  ];

  tex.enable = false;

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
    '';
  };
}
