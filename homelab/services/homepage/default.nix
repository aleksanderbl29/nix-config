{
  config,
  lib,
  ...
}:
let
  service = "homepage-dashboard";
  cfg = config.homelab.services.homepage;
  homelab = config.homelab;
in
{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption {
      description = "Enable ${service}";
    };
    misc = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (
        lib.types.attrsOf (
          lib.types.submodule {
            options = {
              description = lib.mkOption {
                type = lib.types.str;
              };
              href = lib.mkOption {
                type = lib.types.str;
              };
              siteMonitor = lib.mkOption {
                type = lib.types.str;
              };
              icon = lib.mkOption {
                type = lib.types.str;
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    services.glances.enable = true;

    services.${service} = {
      enable = true;
      environmentFile = builtins.toFile "homepage.env" "HOMEPAGE_ALLOWED_HOSTS=${homelab.baseDomain}";
      customCSS = ''
        body, html {
          font-family: SF Pro Display, Helvetica, Arial, sans-serif !important;
        }
        .font-medium {
          font-weight: 700 !important;
        }
        .font-light {
          font-weight: 500 !important;
        }
        .font-thin {
          font-weight: 400 !important;
        }
        #information-widgets {
          padding-left: 1.5rem;
          padding-right: 1.5rem;
        }
        div#footer {
          display: none;
        }
        .services-group.basis-full.flex-1.px-1.-my-1 {
          padding-bottom: 3rem;
        };
      '';
      settings = {
        layout = [
          {
            Glances = {
              header = false;
              style = "row";
              columns = 4;
            };
          }
          {
            Arr = {
              header = true;
              style = "column";
            };
          }
          {
            Downloads = {
              header = true;
              style = "column";
            };
          }
          {
            Media = {
              header = true;
              style = "column";
            };
          }
          {
            Services = {
              header = true;
              style = "column";
            };
          }
        ];
        headerStyle = "clean";
        statusStyle = "dot";
        hideVersion = "true";
      };
      services =
        let
          homepageCategories = [
            "Arr"
            "Media"
            "Downloads"
            "Services"
            "Smart Home"
          ];
          hl = config.homelab.services;
          # Get all enabled homelab services that have homepage configuration
          enabledHomelabServices = lib.filterAttrs (
            _: service: (builtins.isAttrs service) && (service.enable or false) && (service ? homepage)
          ) hl;

          # Group services by category
          homepageServices =
            category:
            lib.filterAttrs (_: service: service.homepage.category == category) enabledHomelabServices;

          # Convert services to homepage format
          formatServices =
            services:
            lib.mapAttrsToList (_name: service: {
              "${service.homepage.name}" = {
                icon = service.homepage.icon;
                description = service.homepage.description;
                href = "https://${service.url}";
                siteMonitor = "https://${service.url}";
              };
            }) services;
        in
        # Create sections for each category that has services
        (lib.concatMap (
          cat:
          let
            categoryServices = homepageServices cat;
          in
          lib.optional (categoryServices != { }) {
            "${cat}" = formatServices categoryServices;
          }
        ) homepageCategories)
        ++ [
          { Misc = cfg.misc; }
        ]
        ++ [
          {
            Glances =
              let
                port = toString config.services.glances.port;
              in
              [
                {
                  Info = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "info";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  "CPU Temp" = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "sensor:Package id 0";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  Processes = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "process";
                      chart = false;
                      version = 4;
                    };
                  };
                }
                {
                  Network = {
                    widget = {
                      type = "glances";
                      url = "http://localhost:${port}";
                      metric = "network:enp2s0";
                      chart = false;
                      version = 4;
                    };
                  };
                }
              ];
          }
        ];
    };

    services.caddy.virtualHosts."${homelab.baseDomain}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString config.services.${service}.listenPort}
      '';
    };
  };
}
