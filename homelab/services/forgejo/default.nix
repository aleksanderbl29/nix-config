{ config, lib, ... }:
let
  cfg = config.homelab.services.forgejo;
  homelab = config.homelab;
in
{
  options.homelab.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo Git server";
    url = lib.mkOption {
      type = lib.types.str;
      default = "git.${homelab.baseDomain}";
    };
    proxyUrl = lib.mkOption {
      type = lib.types.str;
      default = "git.aleksanderbl.dk";
      description = "Public URL through the proxy (e.g., git.aleksanderbl.dk)";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3001;
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/forgejo";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Forgejo";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Git repository hosting service";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "forgejo.svg";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Development";
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      stateDir = cfg.dataDir;
      lfs.enable = true;
      settings = {
        server = {
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = cfg.port;
          DOMAIN = cfg.proxyUrl;
          ROOT_URL = "https://${cfg.proxyUrl}";
          PROTOCOL = "http";
          LANDING_PAGE = "/aleksanderbl29";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
      };
    };

    # Configure Caddy reverse proxy using homelab TLS
    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };

    # Create necessary directories
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 forgejo forgejo - -"
    ];

    # Ensure forgejo user is in the homelab group for proper integration
    users.users.forgejo.extraGroups = [ homelab.group ];
  };
}
