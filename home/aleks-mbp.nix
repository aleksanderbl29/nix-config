{ ... }:
{
  # imports = [
  #   # ./vscode.nix
  # ];

  home.file.".Renviron" = {
    text = ''
      TESTTHAT_CPUS=6
    '';
  };
}
