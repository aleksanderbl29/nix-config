{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab;
  # Collect subdomains from homelab.publicExpose where value is true
  exposedServices = lib.attrNames (lib.filterAttrs (_: v: v == true) cfg.publicExpose);
  # Exclude status from homelab services since it runs locally on nix-proxy-1
  homelabServices = lib.filter (s: s != "status") exposedServices;
  homelabServiceMatcher = lib.concatStringsSep "|" homelabServices;
  homelabServicePattern =
    if homelabServiceMatcher == "" then "(^$)" else "(" + homelabServiceMatcher + ")";
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
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

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

            # Manual override: status/gatus runs locally on nix-proxy-1
            ${lib.optionalString (cfg.services.gatus.enable or false) ''
              @status header_regexp Host ^status\.aleksanderbl\.dk
              handle @status {
                reverse_proxy http://127.0.0.1:${toString cfg.services.gatus.port}
              }
            ''}

            # Route homelab services to internal domain
            @homelab header_regexp Host ^${homelabServicePattern}\.aleksanderbl\.dk
            handle @homelab {
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
