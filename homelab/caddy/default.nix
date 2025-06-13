{
  lib,
  config,
  ...
}:
let
  service = "caddy";
  cfg = config.homelab.${service};
  homelab = config.homelab;
in
{
  options.homelab.${service} = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    extraVirtualHosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          extraConfig = lib.mkOption {
            type = lib.types.str;
            description = "Extra Caddy configuration for this virtual host";
          };
        };
      });
      default = {};
      description = "Additional virtual hosts to configure in Caddy";
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "acme@aleksanderbl.dk";
      certs.${homelab.baseDomain} = {
        reloadServices = [ "caddy.service" ];
        domain = "${homelab.baseDomain}";
        extraDomainNames = [ "*.${homelab.baseDomain}" ];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        group = homelab.group;
        environmentFile = homelab.cloudflare.dnsCredentialsFile;
      };
    };
    services.caddy = {
      enable = true;
      virtualHosts = cfg.extraVirtualHosts;
    };
  };
}
