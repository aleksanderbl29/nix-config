{ config, lib, ... }:
let
  cfg = config.homelab.services.karakeep;
  homelab = config.homelab;
in
{
  options.homelab.services.karakeep = {
    enable = lib.mkEnableOption "Karakeep bookmark management service";

    url = lib.mkOption {
      type = lib.types.str;
      default = "bookmarks.local.aleksanderbl.dk";
      description = "URL where Karakeep will be accessible";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port where Karakeep will be accessible";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Bookmarks";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "AI-powered bookmark management with automatic tagging";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-karakeep.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    # Configure the actual karakeep service
    services.karakeep = {
      enable = true;

      # Enable Meilisearch for full text search
      meilisearch.enable = true;

      # Enable browser service for screenshots
      browser.enable = true;
      browser.port = 9222;

      environmentFile = "/var/lib/karakeep/secrets.env";

      # Environment variables for configuration
      extraEnvironment = {
        # Basic configuration
        NODE_ENV = "production";

        # Database configuration (SQLite by default)
        DATABASE_URL = "sqlite:///var/lib/karakeep/karakeep.db";

        NEXTAUTH_URL = "https://bookmarks.aleksanderbl.dk";

        # Storage configuration (local filesystem)
        STORAGE_BACKEND = "local";
        STORAGE_LOCAL_PATH = "/var/lib/karakeep/storage";

        # Security configuration
        SESSION_SECRET = "change-me-in-production";

        # Optional: Enable OAuth if configured
        # OAUTH_PROVIDER = "google";
        # OAUTH_CLIENT_ID = "";
        # OAUTH_CLIENT_SECRET = "";
        # OAUTH_REDIRECT_URI = "https://${cfg.url}/auth/callback";
      };
    };

    # Create necessary directories
    systemd.tmpfiles.rules = [
      "d /var/lib/karakeep 0750 karakeep karakeep - -"
      "d /var/lib/karakeep/storage 0750 karakeep karakeep - -"
      "d /var/lib/karakeep/secrets 0750 karakeep karakeep - -"
    ];

    # Ensure karakeep user is in the homelab group for proper integration
    users.users.karakeep.extraGroups = [ homelab.group ];

    # Configure Caddy reverse proxy using homelab TLS
    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
