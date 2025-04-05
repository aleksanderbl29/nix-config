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
    # ./traefik.nix
    ./beszel.nix
    ./littlelink.nix
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

    # Create required Docker networks
    systemd.services.docker-networks = {
      description = "Create Docker networks";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      wantedBy = [ "docker.service" ];
      after = [ "docker.service" ];
      path = [ config.virtualisation.docker.package ];
      script = ''
        # Create the 'proxy' network if it doesn't exist
        if ! docker network ls | grep -q proxy; then
          docker network create proxy
        fi

        # Create the 'external' network if it doesn't exist
        if ! docker network ls | grep -q external; then
          docker network create external
        fi
      '';
    };
  };
}
