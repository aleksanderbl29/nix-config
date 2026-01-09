{ lib, config, ... }:
let
  cfg = config.homelab;
  hasEnabledServices = lib.any (service: (builtins.isAttrs service) && (service.enable or false)) (
    lib.attrValues cfg.services
  );
in
{
  config = lib.mkIf (cfg.enable || hasEnabledServices) {
    services.caddy.virtualHosts = lib.mkMerge [
      # External service reverse proxies
      {
        "hyperhdr.${cfg.baseDomain}" = {
          extraConfig = ''
            tls ${cfg.tls.certFile} ${cfg.tls.keyFile}
            reverse_proxy http://hyperhdr:8090
          '';
        };
      }
      {
        "ha.${cfg.baseDomain}" = {
          extraConfig = ''
            tls ${cfg.tls.certFile} ${cfg.tls.keyFile}
            reverse_proxy http://homeassistant:8123 {
              header_up X-Forwarded-Proto {scheme}
              header_up X-Forwarded-Host {host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Real-IP {remote_host}
            }
          '';
        };
      }
      # {
      #   "another-service.${cfg.baseDomain}" = {
      #     extraConfig = ''
      #       tls ${cfg.tls.certFile} ${cfg.tls.keyFile}
      #       reverse_proxy http://192.168.1.101:3000
      #     '';
      #   };
      # }
    ];
  };
}
