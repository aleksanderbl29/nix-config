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
    ./actual-budget.nix
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
        # Use overlay2 for better compatibility
        storageDriver = "overlay2";
      };
      oci-containers = {
        backend = "docker";
      };
    };

    # Ensure Docker socket has proper permissions and restart behavior
    systemd.services.docker.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
    };

    # Create required Docker networks
    systemd.services.docker-networks = {
      description = "Create Docker networks";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "5s";
      };
      wantedBy = [ "docker.service" ];
      after = [ "docker.service" ];
      path = [ config.virtualisation.docker.package ];
      script = ''
        # Wait for Docker to be ready
        sleep 5

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
