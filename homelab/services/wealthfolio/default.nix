{ config, lib, ... }:
let
  cfg = config.homelab.services.wealthfolio;
  homelab = config.homelab;
in
{
  options.homelab.services.wealthfolio = {
    enable = lib.mkEnableOption "Wealthfolio";
    url = lib.mkOption {
      type = lib.types.str;
      default = "wealthfolio.${homelab.baseDomain}";
      description = "HTTPS hostname, accessible only from the tailnet.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8088;
      description = "Loopback port used by the server and Caddy.";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/wealthfolio-secrets/key";
      description = "Runtime file containing the persistent base64-encoded 32-byte secret key.";
    };
    authPasswordHashFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/wealthfolio-secrets/password-hash";
      description = "Runtime file containing the Argon2id login password hash.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Wealthfolio";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Private investment and portfolio tracking";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "wealthfolio.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Services";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (homelab.publicExpose.wealthfolio or false) == false;
        message = "Wealthfolio must remain private to the tailnet.";
      }
    ];

    services.wealthfolio = {
      enable = true;
      address = "127.0.0.1";
      port = cfg.port;
      openFirewall = false;
      secretKeyFile = cfg.secretKeyFile;
      authPasswordHashFile = cfg.authPasswordHashFile;
      authRequired = true;
      corsAllowOrigins = "https://${cfg.url}";
      cookieSecure = "true";
    };

    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
      # Match the direct peer, never a client-supplied forwarding header.
      @tailnet remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
      handle @tailnet {
        reverse_proxy 127.0.0.1:${toString cfg.port}
      }
      handle {
        respond "Tailnet access only" 403
      }
    '';
  };
}
