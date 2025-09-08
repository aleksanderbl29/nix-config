{ lib, config, ... }:
let
  cfg = config.homelab;
in
{
  config = lib.mkIf cfg.enable {
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
