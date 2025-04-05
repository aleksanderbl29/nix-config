{
  config,
  lib,
  ...
}:

let
  cfg = config.docker.beszel-hub;
in
{
  options.docker.beszel-hub = with lib; {
    enable = mkEnableOption "Beszel Hub service" // {
      default = false;
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/beszel";
      description = "Directory to store Beszel data";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure data directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root - -"
    ];

    # Configure Docker container
    virtualisation.oci-containers = {
      containers = {
        beszel = {
          image = "henrygd/beszel";
          ports = [
            "8090:8090"
          ];
          volumes = [
            "beszel_data:/beszel_data"
          ];
          labels = {
            "com.centurylinklabs.watchtower.monitor-only" = "false";
            "traefik.docker.network" = "proxy";
            "traefik.enable" = "true";
            "traefik.http.middlewares.beszel-https-redirect.redirectscheme.scheme" = "https";
            "traefik.http.routers.beszel-secure.entrypoints" = "https";
            "traefik.http.routers.beszel-secure.rule" = "Host(`beszel.local.aleksanderbl.dk`)";
            "traefik.http.routers.beszel-secure.service" = "beszel";
            "traefik.http.routers.beszel-secure.tls" = "true";
            "traefik.http.routers.beszel.entrypoints" = "http";
            "traefik.http.routers.beszel.middlewares" = "beszel-https-redirect";
            "traefik.http.routers.beszel.rule" = "Host(`beszel.local.aleksanderbl.dk`)";
            "traefik.http.services.beszel.loadbalancer.server.port" = "8090";
          };
        };
      };
    };
  };
}
