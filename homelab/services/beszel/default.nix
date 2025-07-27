{ config, lib, ... }:
let
  cfg = config.homelab.services.beszel;
  homelab = config.homelab;
in
{
  options.homelab.services.beszel = {
    enable = lib.mkEnableOption "Beszel monitoring and system dashboard";

    url = lib.mkOption {
      type = lib.types.str;
      default = "beszel.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8090;
      description = "Port where Beszel is running";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/beszel";
      description = "Directory to store Beszel data";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Beszel";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "System monitoring and resource dashboard";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "beszel.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Monitoring";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure data directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root - -"
    ];

    # Configure Docker container
    virtualisation.oci-containers.containers.beszel = {
      image = "henrygd/beszel";
      ports = [
        "${toString cfg.port}:8090"
      ];
      volumes = [
        "beszel_data:/beszel_data"
      ];
      extraOptions = [
        "--network=proxy"
      ];
    };

    # Caddy virtual host configuration
    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
