{ config, lib, pkgs, ... }:
let
  cfg = config.homelab.services.umami;
  homelab = config.homelab;
in
{
  options.homelab.services.umami = {
    enable = lib.mkEnableOption "Umami analytics service";

    url = lib.mkOption {
      type = lib.types.str;
      default = "umami.local.aleksanderbl.dk";
      description = "URL where Umami will be accessible";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3002;
      description = "Port where Umami will be accessible";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Umami";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Analytics platform for tracking website usage";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-umami.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };

    generateAppSecret = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Generate a random app secret for Umami";
    };

  };

  config = lib.mkIf cfg.enable {
    # Configure the actual umami service
    services.umami = {
      enable = true;
      settings = {
        PORT = cfg.port;
        DISABLE_TELEMETRY = true;
        APP_SECRET_FILE = "/var/lib/umami/app-secret";
      };
    };

    system.activationScripts.umami-app-secret = lib.mkIf cfg.generateAppSecret {
      text = ''
        if [ ! -f /var/lib/umami/app-secret ]; then
          mkdir -p /var/lib/umami
          ${pkgs.openssl}/bin/openssl rand -hex 32 > /var/lib/umami/app-secret
          chmod 600 /var/lib/umami/app-secret
          chown umami:umami /var/lib/umami/app-secret 2>/dev/null || true
        fi
      '';
    };

    # Configure Caddy reverse proxy using homelab TLS
    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
