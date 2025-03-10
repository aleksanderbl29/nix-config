{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.tex;
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      dvisvgm
      dvipng
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
      titling
      framed
      inconsolata
      collection-fontsrecommended
      ;
  };
in
{
  options.tex.enable = mkEnableOption "texlive installation";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tex
    ];
  };
}
