{ config, lib, ... }:
let
  cfg = config.homelab.services.jellyfin;
  homelab = config.homelab;
in
{
  options.homelab.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";

    url = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8096;
      description = "Port where Jellyfin is running";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyfin";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Media server and streaming platform";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };

  config = lib.mkIf cfg.enable {
    # Caddy virtual host configuration for Jellyfin
    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls /var/lib/acme/${homelab.baseDomain}/cert.pem /var/lib/acme/${homelab.baseDomain}/key.pem
        reverse_proxy http://127.0.0.1:${toString cfg.port} {
          header_up X-Forwarded-Proto {scheme}
          header_up X-Forwarded-Host {host}
          header_up X-Forwarded-For {remote}
          header_up X-Real-IP {remote}
        }
      '';
    };
  };
}
