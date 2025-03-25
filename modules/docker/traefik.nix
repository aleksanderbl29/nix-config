{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.docker.traefik;
in
{
  options.docker.traefik = with lib; {
    enable = mkEnableOption "Traefik reverse proxy" // {
      default = false;
    };

    environmentFile = mkOption {
      type = types.str;
      description = "Path to the environment file containing CF_API_EMAIL and CF_API_KEY";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/traefik";
      description = "Directory to store Traefik data";
    };

    staticConfigFile = mkOption {
      type = types.path;
      default = ./files/traefik/traefik.yml;
      description = "Path to traefik.yml static configuration file";
    };

    dynamicConfigFile = mkOption {
      type = types.path;
      default = ./files/traefik/config.yml;
      description = "Path to dynamic configuration file";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create the proxy network using a systemd service
    systemd.services.docker-network-proxy = {
      description = "Create Docker proxy network";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      before = [ "docker-traefik.service" ];
      wantedBy = [ "docker-traefik.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.docker}/bin/docker network create proxy || true";
      };
    };

    # Ensure data directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root - -"
    ];

    # Configure Traefik container
    virtualisation.oci-containers = {
      backend = "docker";
      containers.traefik = {
        dependsOn = [ "proxy" ];
        image = "traefik:v3.3.4";
        autoStart = true;
        environmentFiles = [ cfg.environmentFile ];
        environment = {
          API_INSECURE = "true";
        };
        extraOptions = [
          "--network=proxy"
          "--security-opt=no-new-privileges:true"
        ];
        ports = [
          "80:80"
          "443:443"
          # "8080:8080"  # Commented out as in original
        ];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          "${cfg.staticConfigFile}:/traefik.yml:ro"
          "${cfg.dataDir}/acme.json:/acme.json"
          "${cfg.dynamicConfigFile}:/config.yml:ro"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.entrypoints" = "http";
          "traefik.http.routers.traefik.rule" = "Host(`traefik-dashboard.local.aleksanderbl.dk`)";
          "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme" = "https";
          "traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto" = "https";
          "traefik.http.routers.traefik.middlewares" = "traefik-https-redirect";
          "traefik.http.routers.traefik-secure.entrypoints" = "https";
          "traefik.http.routers.traefik-secure.rule" = "Host(`traefik-dashboard.local.aleksanderbl.dk`)";
          "traefik.http.routers.traefik-secure.tls" = "true";
          "traefik.http.routers.traefik-secure.tls.certresolver" = "cloudflare";
          "traefik.http.routers.traefik-secure.tls.domains[0].main" = "local.aleksanderbl.dk";
          "traefik.http.routers.traefik-secure.tls.domains[0].sans" = "*.local.aleksanderbl.dk";
          "traefik.http.routers.traefik-secure.service" = "api@internal";
        };
      };
    };

    # Create acme.json with correct permissions
    system.activationScripts.traefik-acme = ''
      touch ${cfg.dataDir}/acme.json
      chmod 600 ${cfg.dataDir}/acme.json
    '';
  };
}
