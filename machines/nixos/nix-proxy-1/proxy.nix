{ lib, config, pkgs, ... }:
let
  cfg = config.homelab;
  # Collect subdomains from homelab.publicExpose where value is true
  exposedServices = lib.attrNames (lib.filterAttrs (_: v: v == true) cfg.publicExpose);
  exposedMatcher = lib.concatStringsSep "|" (lib.map (s: "(" + s + ")") exposedServices);
  hostPattern = if exposedMatcher == "" then "(^$)" else exposedMatcher;
in
{
  imports = [
    # Reuse homelab options (baseDomain, tls, etc.)
    ../../../homelab
  ];

  options.proxy = {
    enable = lib.mkEnableOption "Enable wildcard reverse proxy from *.aleksanderbl.dk to selected *.${cfg.baseDomain} based on homelab.publicExpose flags";
  };

  config = lib.mkIf config.proxy.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    users.users.caddy.extraGroups = [ cfg.group ];
    systemd.tmpfiles.rules = [
      "d /var/lib/caddy 0750 caddy caddy"
    ];

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

      virtualHosts = {
        "*.aleksanderbl.dk" = {
          extraConfig = ''
            tls /var/lib/acme/aleksanderbl.dk/cert.pem /var/lib/acme/aleksanderbl.dk/key.pem

            @sub header_regexp Host (^${hostPattern})\.aleksanderbl\.dk
            handle @sub {
              reverse_proxy {http.regexp.sub.1}.${cfg.baseDomain}:443 {
                transport http {
                  tls
                }
                header_up Host {http.regexp.sub.1}.${cfg.baseDomain}
              }
            }

            respond 404
          '';
        };

        "aleksanderbl.dk" = {
          extraConfig = ''
            tls /var/lib/acme/aleksanderbl.dk/cert.pem /var/lib/acme/aleksanderbl.dk/key.pem
            redir https://${cfg.baseDomain} permanent
          '';
        };
      };
    };

    services.journald.extraConfig = ''
      SystemMaxUse=200M
    '';
  };
}
