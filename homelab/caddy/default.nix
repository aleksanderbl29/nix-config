{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab;
  hasEnabledServices = lib.any (service: service.enable) (lib.attrValues cfg.services);
in
{
    config = lib.mkIf (cfg.enable || hasEnabledServices) {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    # ACME configuration for DNS challenge
    security.acme = {
      acceptTerms = true;
      defaults.email = "aleksanderbl@live.dk";

      certs."${cfg.baseDomain}" = {
        group = "caddy";
        domain = cfg.baseDomain;
        extraDomainNames = [ "*.${cfg.baseDomain}" "aleksanderbl.dk" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = "/var/lib/caddy/cloudflare_api_token_env";
      };
    };

    services.caddy = {
      enable = true;
      group = "caddy";
      email = "aleksanderbl@live.dk";

      # Global Caddy configuration
      globalConfig = ''
        email aleksanderbl@live.dk
      '';

      # Virtual hosts configuration
      virtualHosts = lib.mkMerge [
        # Base domain redirect to dashboard
        {
          "aleksanderbl.dk" = {
            extraConfig = ''
              tls /var/lib/acme/${cfg.baseDomain}/cert.pem /var/lib/acme/${cfg.baseDomain}/key.pem
              redir https://dashboard.${cfg.baseDomain} permanent
            '';
          };
        }
      ];
    };

    users.users.caddy.extraGroups = [ cfg.group ];

    # Ensure /var/lib/caddy directory exists with proper permissions
    systemd.tmpfiles.rules = [
      "d /var/lib/caddy 0750 caddy caddy"
    ];
  };
}
