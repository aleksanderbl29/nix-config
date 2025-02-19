{ ... }:
{
  imports = [
    ./tex.nix
  ];

  tex.enable = false;

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
    '';
  };
}
