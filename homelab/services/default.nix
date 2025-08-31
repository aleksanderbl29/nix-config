{
  config,
  lib,
  ...
}:
let
  cfg = config.homelab;
  # Check if any homelab service is enabled
  hasEnabledServices = lib.any (service: service.enable) (lib.attrValues cfg.services);
in
{
  # Automatically enable Docker and OCI containers when any homelab service is enabled
  config = lib.mkIf (cfg.enable || hasEnabledServices) {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
      storageDriver = "overlay2"; # Use overlay2 instead of zfs for better compatibility
    };

    virtualisation.oci-containers = {
      backend = "docker";
    };

    # Enable systemd-resolved for better DNS handling
    services.resolved.enable = true;

    # logrotate
    services.logrotate.enable = true;
  };

  # Import all service modules
  # Each service follows the pattern:
  # - Self-contained module with options
  # - Homepage metadata for auto-discovery
  # - Automatic Caddy virtual host configuration
  imports = [
    ./homepage
    ./immich
    ./jellyfin
    ./beszel
    ./littlelink
    ./karakeep
  ];
}
