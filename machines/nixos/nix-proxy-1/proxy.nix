{
  lib,
  config,
  ...
}:
let
  cfg = config.homelab;
  tlsCert = "/var/lib/acme/aleksanderbl.dk/cert.pem";
  tlsKey = "/var/lib/acme/aleksanderbl.dk/key.pem";

  # All publicExpose entries except "status" (handled locally via gatus)
  # Filter out false values (not exposed) and the local gatus service
  remoteExposedServices = lib.filterAttrs (
    name: v: name != "status" && v != false
  ) cfg.publicExpose;

  # Build a Caddy virtual host for a service given its target machine domain
  makeServiceVhost =
    name: target:
    let
      targetDomain = if target == true then cfg.baseDomain else target;
    in
    lib.nameValuePair "${name}.aleksanderbl.dk" {
      extraConfig = ''
        tls ${tlsCert} ${tlsKey}
        reverse_proxy ${name}.${targetDomain}:443 {
          transport http {
            tls
          }
          header_up Host ${name}.${targetDomain}
        }
      '';
    };
in
{
  imports = [
    # Reuse homelab options (baseDomain, tls, publicExpose, etc.)
    ../../../homelab
  ];

  options.proxy = {
    enable = lib.mkEnableOption "Enable public reverse proxy from *.aleksanderbl.dk to per-service machine domains";
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

      virtualHosts = lib.mkMerge [
        # Per-service vhosts: foo.aleksanderbl.dk → foo.<machineDomain>:443
        (lib.mapAttrs' makeServiceVhost remoteExposedServices)

        # Status/gatus runs locally on nix-proxy-1 itself
        (lib.optionalAttrs (cfg.services.gatus.enable or false) {
          "status.aleksanderbl.dk" = {
            extraConfig = ''
              tls ${tlsCert} ${tlsKey}
              reverse_proxy http://127.0.0.1:${toString cfg.services.gatus.port}
            '';
          };
        })

        # aleksanderbl.dk → baseDomain redirect
        {
          "aleksanderbl.dk" = {
            extraConfig = ''
              tls ${tlsCert} ${tlsKey}
              redir https://${cfg.baseDomain} permanent
            '';
          };
        }

        # Catch-all 404 for any other *.aleksanderbl.dk subdomain
        {
          "*.aleksanderbl.dk" = {
            extraConfig = ''
              tls ${tlsCert} ${tlsKey}
              respond 404
            '';
          };
        }
      ];
    };

    services.journald.extraConfig = ''
      SystemMaxUse=200M
    '';
  };
}
