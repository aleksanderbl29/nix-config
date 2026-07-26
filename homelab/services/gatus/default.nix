{ config, lib, ... }:
let
  cfg = config.homelab.services.gatus;
  homelab = config.homelab;

  enabledProviders = lib.filterAttrs (_: provider: provider.enable) cfg.alerting.providers;
  enabledProviderNames = lib.attrNames enabledProviders;

  alertingSettings = lib.mapAttrs (
    _: provider:
    provider.settings
    // lib.optionalAttrs (cfg.alerting.defaultAlert != { }) {
      default-alert = cfg.alerting.defaultAlert;
    }
  ) enabledProviders;

  endpoints = map (
    endpoint:
    let
      base = builtins.removeAttrs endpoint [ "alerts" ];
      alerts =
        if endpoint.alerts != null then
          endpoint.alerts
        else if cfg.alerting.enable then
          map (type: { inherit type; }) enabledProviderNames
        else
          null;
    in
    base // lib.optionalAttrs (alerts != null) { inherit alerts; }
  ) cfg.endpoints;
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
            alerts = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf lib.types.attrs);
              default = null;
              description = ''
                Per-endpoint alert overrides. null (default) attaches one alert per
                enabled alerting provider. Set to [] to disable alerts for this endpoint.
              '';
              example = [
                { type = "slack"; }
                {
                  type = "discord";
                  failure-threshold = 5;
                }
              ];
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

    alerting = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable alerting and attach enabled providers to endpoints";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Systemd environment file with secrets for alerting providers.
          Reference variables in provider settings with ''${VAR_NAME}
          (e.g. webhook-url = "''${SLACK_WEBHOOK_URL}").
        '';
        example = "/var/lib/gatus/secrets.env";
      };

      defaultAlert = lib.mkOption {
        type = lib.types.attrs;
        default = {
          enabled = true;
          failure-threshold = 1;
          success-threshold = 2;
          send-on-resolved = true;
          description = "health check failed";
        };
        description = ''
          Shared default-alert applied to every enabled provider.
          See https://github.com/TwiN/gatus#setting-a-default-alert
        '';
      };

      providers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "this Gatus alerting provider";

              settings = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = ''
                  Provider-specific settings passed through to Gatus (kebab-case keys).
                  Provider name must match a Gatus alerting type (slack, discord, telegram, …).
                  See https://github.com/TwiN/gatus#alerting
                '';
                example = {
                  webhook-url = "\${SLACK_WEBHOOK_URL}";
                  title = "Homelab status";
                };
              };
            };
          }
        );
        default = { };
        description = ''
          Alerting providers keyed by Gatus provider name. Enable the ones you want;
          switching providers is just enable/disable (and settings).
        '';
        example = {
          slack = {
            enable = true;
            settings.webhook-url = "\${SLACK_WEBHOOK_URL}";
          };
          discord = {
            enable = false;
            settings.webhook-url = "\${DISCORD_WEBHOOK_URL}";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.alerting.enable || enabledProviders != { };
        message = "homelab.services.gatus.alerting.enable requires at least one enabled entry in alerting.providers";
      }
    ];

    # Create data directory for SQLite database
    systemd.tmpfiles.rules = lib.mkIf cfg.storage.enable [
      "d ${cfg.storage.dataDir} 0750 gatus gatus - -"
    ];

    services.gatus = {
      enable = true;
      environmentFile = cfg.alerting.environmentFile;
      settings = {
        web.port = cfg.port;
        inherit endpoints;
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
      }
      // lib.optionalAttrs cfg.alerting.enable {
        alerting = alertingSettings;
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
