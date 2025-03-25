{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.docker;
in
{
  imports = [
    ./traefik.nix
    ./beszel.nix
  ];

  options.docker = {
    enable = mkEnableOption "docker";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
      oci-containers = {
        backend = "docker";
      };
    };
  };

}
