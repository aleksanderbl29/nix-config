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
              type = lib.types.addCheck (lib.types.strMatching "^[0-9]+(ms|s|m|h|d)$") (
                value:
                let
                  # Parse duration string to seconds
                  parseDuration =
                    s:
                    let
                      match = builtins.match "^([0-9]+)(ms|s|m|h|d)$" s;
                      num = if match != null then builtins.fromJSON (builtins.elemAt match 0) else 0;
                      unit = if match != null then builtins.elemAt match 1 else "";
                      multipliers = {
                        ms = 0.001;
                        s = 1;
                        m = 60;
                        h = 3600;
                        d = 86400;
                      };
                    in
                    num * (multipliers.${unit} or 0);
                  seconds = parseDuration value;
                in
                seconds >= 30 && seconds <= 3600
              );
              default = "5m";
              description = "Interval between checks (30s to 1h). Format: number followed by unit (ms, s, m, h, or d). Examples: '30s', '5m', '1h'";
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
        ui = {
          title = "Status Page | Aleksander Bang-Larsen";
          header = "Status Page";
          dashboard-heading = "Aleksanders Status Page";
          dashboard-subheading = "Overview of the status of my services, websites and projects.";
          link = "https://status.aleksanderbl.dk";
        };
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
