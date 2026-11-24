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
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8088;
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Wealthfolio";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Investment tracking";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "wealthfolio.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    services.wealthfolio = {
      enable = true;
      address = "127.0.0.1";
      port = cfg.port;
      secretKeyFile = "/var/lib/wealthfolio/secret-key";
      authPasswordHashFile = "/var/lib/wealthfolio/password-hash";
      corsAllowOrigins = "https://${cfg.url}";
      cookieSecure = "true";
    };

    services.caddy.virtualHosts."${cfg.url}".extraConfig = ''
      tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
      reverse_proxy http://127.0.0.1:${toString cfg.port}
    '';
  };
}
