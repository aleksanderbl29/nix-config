# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."actual-budget-actual_server" = {
    image = "docker.io/actualbudget/actual-server:latest";
    volumes = [
      "actual-budget_actual-data:/data:rw"
    ];
    ports = [
      "5006:5006/tcp"
    ];
    labels = {
      "com.centurylinklabs.watchtower.monitor-only" = "false";
      "traefik.docker.network" = "proxy";
      "traefik.enable" = "true";
      "traefik.http.middlewares.actual-budget-https-redirect.redirectscheme.scheme" = "https";
      "traefik.http.routers.actual-budget-secure.entrypoints" = "https";
      "traefik.http.routers.actual-budget-secure.rule" = "Host(`actual.local.aleksanderbl.dk`)";
      "traefik.http.routers.actual-budget-secure.service" = "actual-budget";
      "traefik.http.routers.actual-budget-secure.tls" = "true";
      "traefik.http.routers.actual-budget.entrypoints" = "http";
      "traefik.http.routers.actual-budget.middlewares" = "actual-budget-https-redirect";
      "traefik.http.routers.actual-budget.rule" = "Host(`actual.local.aleksanderbl.dk`)";
      "traefik.http.services.actual-budget.loadbalancer.server.port" = "5006";
    };
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=node src/scripts/health-check.js"
      "--health-interval=1m0s"
      "--health-retries=3"
      "--health-start-period=20s"
      "--health-timeout=10s"
      "--network-alias=actual_server"
      "--network=proxy"
    ];
  };
  systemd.services."docker-actual-budget-actual_server" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-volume-actual-budget_actual-data.service"
    ];
    requires = [
      "docker-volume-actual-budget_actual-data.service"
    ];
    partOf = [
      "docker-compose-actual-budget-root.target"
    ];
    wantedBy = [
      "docker-compose-actual-budget-root.target"
    ];
  };

  # Volumes
  systemd.services."docker-volume-actual-budget_actual-data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect actual-budget_actual-data || docker volume create actual-budget_actual-data
    '';
    partOf = [ "docker-compose-actual-budget-root.target" ];
    wantedBy = [ "docker-compose-actual-budget-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-actual-budget-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
