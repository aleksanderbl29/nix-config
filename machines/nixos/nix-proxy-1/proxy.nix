{ lib, config, pkgs, ... }:
let
  cfg = config.homelab;
in
{
  imports = [
    # Reuse homelab options (baseDomain, tls, etc.)
    ../../../homelab
  ];

  options.proxy = {
    enable = lib.mkEnableOption "Enable wildcard reverse proxy from *.aleksanderbl.dk to *.${cfg.baseDomain}";
  };

  config = lib.mkIf config.proxy.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    # Ensure Caddy has access to certs and cloudflare token
    users.users.caddy.extraGroups = [ cfg.group ];
    systemd.tmpfiles.rules = [
      "d /var/lib/caddy 0750 caddy caddy"
    ];

    # ACME for public domain using Cloudflare DNS
    security.acme = {
      acceptTerms = true;
      defaults.email = "aleksanderbl@live.dk";
      certs."aleksanderbl.dk" = {
        group = "caddy";
        domain = "aleksanderbl.dk";
        extraDomainNames = [ "*.aleksanderbl.dk" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = "/var/lib/caddy/cloudflare_api_token_env";
      };
    };

    services.caddy = {
      enable = true;
      email = "aleksanderbl@live.dk";
      group = "caddy";

      globalConfig = ''
        email aleksanderbl@live.dk
        admin off
        debug
      '';

      # Caddy virtual hosts
      virtualHosts = {
        # Wildcard listener for the public domain
        "*.aleksanderbl.dk" = {
          extraConfig = ''
            tls /var/lib/acme/aleksanderbl.dk/cert.pem /var/lib/acme/aleksanderbl.dk/key.pem

            @sub header_regexp Host (.*)\.aleksanderbl\.dk
            handle @sub {
              reverse_proxy {http.regexp.sub.1}.${cfg.baseDomain}:443 {
                transport http {
                  tls
                }
                header_up Host {http.regexp.sub.1}.${cfg.baseDomain}
              }
            }
          '';
        };

        # Also cover apex domain -> redirect to homelab base
        "aleksanderbl.dk" = {
          extraConfig = ''
            tls /var/lib/acme/aleksanderbl.dk/cert.pem /var/lib/acme/aleksanderbl.dk/key.pem
            redir https://${cfg.baseDomain} permanent
          '';
        };
      };
    };

    # Basic log file for troubleshooting
    services.journald.extraConfig = ''
      SystemMaxUse=200M
    '';
  };
}
