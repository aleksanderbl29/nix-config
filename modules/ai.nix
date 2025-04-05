{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.litellm;
in
{
  options.services.litellm = {
    enable = mkEnableOption "LiteLLM proxy service";

    port = mkOption {
      type = types.port;
      default = 4000;
      description = "Port number for the LiteLLM proxy to listen on";
    };

    postgresPort = mkOption {
      type = types.port;
      default = 5432;
      description = "Port number for the PostgreSQL database";
    };

    prometheusPort = mkOption {
      type = types.port;
      default = 9090;
      description = "Port number for Prometheus metrics";
    };

    databasePassword = mkOption {
      type = types.str;
      default = "dbpassword9090";
      description = "Password for the PostgreSQL database";
    };

    configFile = mkOption {
      type = types.path;
      description = "Path to the LiteLLM config.yaml file";
    };

    prometheusConfigFile = mkOption {
      type = types.path;
      description = "Path to the Prometheus config file";
    };
  };

  config = mkIf cfg.enable {
    # Ensure required directories exist
    systemd.tmpfiles.rules = [
      "d /var/lib/litellm 0750 root root - -"
      "d /var/lib/postgresql 0750 root root - -"
      "d /var/lib/prometheus 0750 root root - -"
    ];

    virtualisation.oci-containers.containers = {
      litellm = {
        image = "ghcr.io/berriai/litellm:main-stable";
        ports = [ "${toString cfg.port}:4000" ];
        volumes = [
          "${cfg.configFile}:/app/config.yaml"
        ];
        environment = {
          DATABASE_URL = "postgresql://llmproxy:${cfg.databasePassword}@localhost:${toString cfg.postgresPort}/litellm";
          STORE_MODEL_IN_DB = "True";
        };
        dependsOn = [ "litellm-db" ];
        extraOptions = [
          "--network=host"
        ];
        healthcheck = {
          command = [
            "CMD"
            "curl"
            "-f"
            "http://localhost:4000/health/liveliness"
            "||"
            "exit"
            "1"
          ];
          interval = "30s";
          timeout = "10s";
          retries = 3;
          startPeriod = "40s";
        };
      };

      litellm-db = {
        image = "postgres:16";
        ports = [ "${toString cfg.postgresPort}:5432" ];
        environment = {
          POSTGRES_DB = "litellm";
          POSTGRES_USER = "llmproxy";
          POSTGRES_PASSWORD = cfg.databasePassword;
        };
        volumes = [
          "postgres_data:/var/lib/postgresql/data"
        ];
        healthcheck = {
          command = [
            "CMD-SHELL"
            "pg_isready -d litellm -U llmproxy"
          ];
          interval = "1s";
          timeout = "5s";
          retries = 10;
        };
      };

      prometheus = {
        image = "prom/prometheus";
        ports = [ "${toString cfg.prometheusPort}:9090" ];
        volumes = [
          "prometheus_data:/prometheus"
          "${cfg.prometheusConfigFile}:/etc/prometheus/prometheus.yml"
        ];
        cmd = [
          "--config.file=/etc/prometheus/prometheus.yml"
          "--storage.tsdb.path=/prometheus"
          "--storage.tsdb.retention.time=15d"
        ];
        autoStart = true;
      };
    };

    # Open required ports in the firewall
    networking.firewall.allowedTCPPorts = [
      cfg.port
      cfg.postgresPort
      cfg.prometheusPort
    ];
  };
}
