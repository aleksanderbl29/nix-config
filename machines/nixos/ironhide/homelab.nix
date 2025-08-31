{
  config,
  ...
}:
let
  hl = config.homelab;
in
{
  homelab = {
    enable = true;
    services = {
      homepage = {
        enable = true;
      };
      jellyfin = {
        enable = true;
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
      };
      immich = {
        enable = true;
      };
      littlelink = {
        enable = true;
      };
      karakeep = {
        enable = true;
      };
    };
  };

  # Configure the actual karakeep service
  services.karakeep = {
    enable = true;

    # Enable Meilisearch for full text search
    meilisearch.enable = true;

    # Enable browser service for screenshots
    browser.enable = true;
    browser.port = 9222;

    # Environment variables for configuration

    extraEnvironment = {
      # Basic configuration
      NODE_ENV = "production";

      # Database configuration (SQLite by default)
      DATABASE_URL = "sqlite:///var/lib/karakeep/karakeep.db";

      # Storage configuration (local filesystem)
      STORAGE_BACKEND = "local";
      STORAGE_LOCAL_PATH = "/var/lib/karakeep/storage";

      # Security configuration
      SESSION_SECRET = "change-me-in-production";

      # Optional: Enable OAuth if configured
      # OAUTH_PROVIDER = "google";
      # OAUTH_CLIENT_ID = "";
      # OAUTH_CLIENT_SECRET = "";
      # OAUTH_REDIRECT_URI = "https://bookmarks.local.aleksanderbl.dk/auth/callback";
    };
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /var/lib/karakeep 0750 karakeep karakeep - -"
    "d /var/lib/karakeep/storage 0750 karakeep karakeep - -"
  ];

  # Ensure karakeep user is in the homelab group for proper integration
  users.users.karakeep.extraGroups = [ "homelab" ];

  # Configure Caddy reverse proxy for karakeep using homelab TLS
  services.caddy.virtualHosts."bookmarks.local.aleksanderbl.dk" = {
    extraConfig = ''
      tls ${config.homelab.tls.certFile} ${config.homelab.tls.keyFile}
      reverse_proxy http://127.0.0.1:3000
    '';
  };
}
