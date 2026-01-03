{ config, lib, ... }:
let
  cfg = config.homelab.services.gatus;
  homelab = config.homelab;
in
{
  options.homelab.services.gatus = {
    enable = lib.mkEnableOption "Gatus service monitoring";

    url = lib.mkOption {
      type = lib.types.str;
      default = "status.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8091;
      description = "External port where Gatus is accessible";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Gatus";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Service monitoring and status page";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "gatus.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Monitoring";
    };

    endpoints = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the endpoint to monitor";
            };
            group = lib.mkOption {
              type = lib.types.str;
              description = "Group name for organizing endpoints";
            };
            url = lib.mkOption {
              type = lib.types.str;
              description = "URL of the endpoint to monitor";
            };
            interval = lib.mkOption {
              type = lib.types.str;
              default = "5m";
              description = "Interval between checks (e.g., '5m', '1h')";
            };
            conditions = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "[STATUS] == 200" ];
              description = "List of conditions that must be met for the endpoint to be considered healthy";
            };
          };
        }
      );
      default = [ ];
      description = "List of endpoints to monitor";
    };

    storage = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable SQLite storage for persistent data";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/gatus";
        description = "Directory where Gatus data and SQLite database will be stored";
      };

      databaseFile = lib.mkOption {
        type = lib.types.str;
        default = "gatus.db";
        description = "SQLite database filename (stored in dataDir)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Create data directory for SQLite database
    systemd.tmpfiles.rules = lib.mkIf cfg.storage.enable [
      "d ${cfg.storage.dataDir} 0750 gatus gatus - -"
    ];

    services.gatus = {
      enable = true;
      settings = {
        web.port = cfg.port;
        endpoints = cfg.endpoints;
      }
      // lib.optionalAttrs cfg.storage.enable {
        storage = {
          type = "sqlite";
          path = "${cfg.storage.dataDir}/${cfg.storage.databaseFile}";
        };
      };
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
