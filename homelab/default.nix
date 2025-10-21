{ lib, config, ... }:
let
  cfg = config.homelab;
  # Check if any homelab service is enabled
  hasEnabledServices = lib.any (service: service.enable) (lib.attrValues cfg.services);
in
{
  options.homelab = {
    enable = lib.mkEnableOption "The homelab services and configuration variables";

    user = lib.mkOption {
      default = "homelab";
      type = lib.types.str;
      description = ''
        User to run the homelab services as
      '';
    };

    group = lib.mkOption {
      default = "homelab";
      type = lib.types.str;
      description = ''
        Group to run the homelab services as
      '';
    };

    timeZone = lib.mkOption {
      default = "Europe/Copenhagen";
      type = lib.types.str;
      description = ''
        Time zone to be used for the homelab services
      '';
    };

    baseDomain = lib.mkOption {
      default = "local.aleksanderbl.dk";
      type = lib.types.str;
      description = ''
        Base domain name to be used to access the homelab services via Caddy reverse proxy.
        Services will be available at <service>.<baseDomain>
      '';
    };

    tls = lib.mkOption {
      type = lib.types.submodule {
        options = {
          certFile = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/acme/${cfg.baseDomain}/cert.pem";
            description = "Path to the TLS certificate file";
          };
          keyFile = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/acme/${cfg.baseDomain}/key.pem";
            description = "Path to the TLS private key file";
          };
        };
      };
      default = { };
      description = "TLS certificate configuration for homelab services";
    };

    mounts = lib.mkOption {
      type = lib.types.submodule {
        options = {
          fast = lib.mkOption {
            type = lib.types.path;
            default = "/mnt/fast";
            description = "Path to fast storage mount point (SSD/NVMe)";
          };
        };
      };
      default = { };
      description = "Storage mount points for homelab services";
    };

    services = lib.mkOption {
      type = lib.types.submoduleWith { modules = [ ]; };
      default = { };
      description = ''
        Homelab services configuration. Each service is automatically discovered
        by the homepage dashboard when enabled.
      '';
    };

    publicExpose = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = { };
      example = {
        homepage = true;
        jellyfin = false;
      };
      description = "Map of homelab service names to a boolean indicating if they should be exposed via the external proxy (*.aleksanderbl.dk).";
    };
  };

  # Import homelab modules
  imports = [
    ./caddy # Reverse proxy and HTTPS termination
    ./services # All homelab services
    ../modules/beszel-agent.nix # Beszel agent service
  ];

  # Configure basic homelab infrastructure when enabled
  config = lib.mkIf (cfg.enable || hasEnabledServices) {
    # Create homelab user and group
    users = {
      groups.${cfg.group} = {
        gid = 993;
      };
      users.${cfg.user} = {
        uid = 994;
        isSystemUser = true;
        group = cfg.group;
      };
    };

    services.beszel-agent = {
      enable = true;
      port = 45876;
      key = "\"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ5KOjxmMf0QPHln20mOGXxN2QG6yP8pZgKUFyMymTV\"";
    };

    # Set system timezone
    time.timeZone = cfg.timeZone;
  };
}
