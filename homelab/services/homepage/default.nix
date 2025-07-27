{
  config,
  lib,
  ...
}:
let
  service = "homepage-dashboard";
  cfg = config.homelab.services.homepage;
  homelab = config.homelab;

  # Generate services configuration from enabled homelab services
  enabledServices = lib.filterAttrs (name: service: service.enable) homelab.services;

  homelabServices = lib.mapAttrsToList (name: service:
    lib.optionalAttrs (service ? homepage) {
      "${service.homepage.name or name}" = {
        icon = service.homepage.icon or "";
        href = "https://${service.url or "${name}.${homelab.baseDomain}"}";
        description = service.homepage.description or "";
      };
    }
  ) enabledServices;

  servicesConfig = lib.fold (a: b: a // b) {} homelabServices;
in
{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption {
      description = "Enable homepage dashboard";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "dashboard.${homelab.baseDomain}";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable glances for system monitoring
    services.glances.enable = true;

    # Configure homepage dashboard
    services.homepage-dashboard = {
      enable = true;
      listenPort = 7001;
      settings = {
        title = "Homelab Dashboard";
        headerStyle = "clean";
        statusStyle = "dot";
        hideVersion = true;
      };
      services = [
        {
          "Services" = lib.attrValues servicesConfig;
        }
      ];
      widgets = [
        {
          glances = {
            url = "http://127.0.0.1:61208";
            metric = "cpu";
          };
        }
      ];
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls /var/lib/acme/${homelab.baseDomain}/cert.pem /var/lib/acme/${homelab.baseDomain}/key.pem
        reverse_proxy http://127.0.0.1:${toString config.services.homepage-dashboard.listenPort}
      '';
    };
  };
}
