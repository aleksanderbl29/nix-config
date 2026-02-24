{ lib, config, ... }:
let
  cfg = config.homelab;
  hasEnabledServices = lib.any (service: (builtins.isAttrs service) && (service.enable or false)) (
    lib.attrValues cfg.services
  );
  # Derive parent domain from baseDomain by dropping the first label.
  # e.g. "local.aleksanderbl.dk" → "aleksanderbl.dk"
  parentDomain = lib.concatStringsSep "." (lib.tail (lib.splitString "." cfg.baseDomain));
in
{
  config = lib.mkIf (cfg.enable || hasEnabledServices) {
    services.caddy.virtualHosts = lib.mkMerge [
      # Cross-machine remote proxies: <name>.baseDomain → <service>.<machine>.parentDomain
      (lib.mapAttrs' (
        name: proxy:
        let
          upstream = "${proxy.service}.${proxy.machine}.${parentDomain}";
        in
        lib.nameValuePair "${name}.${cfg.baseDomain}" {
          extraConfig = ''
            tls ${cfg.tls.certFile} ${cfg.tls.keyFile}
            reverse_proxy https://${upstream} {
              header_up Host ${upstream}
              header_up X-Forwarded-Proto {scheme}
              header_up X-Forwarded-Host {host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Real-IP {remote_host}
            }
          '';
        }
      ) cfg.remoteProxies)
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
      {
        "soundwave-jellyfin.${cfg.baseDomain}" = {
          extraConfig = ''
            tls ${cfg.tls.certFile} ${cfg.tls.keyFile}
            reverse_proxy http://soundwave:8096
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
