{ config, lib, ... }:
let
  cfg = config.homelab.services.gatus;
  homelab = config.homelab;
in
{
  options.homelab.services.gatus = {
    enable = lib.mkEnableOption "Gatus service monitoring";

    url = lib.mkOption {
      type = lib.types.str;
      default = "status.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8091;
      description = "External port where Gatus is accessible";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Gatus";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Service monitoring and status page";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "gatus.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Monitoring";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gatus = {
      enable = true;
      settings = {
        web.port = cfg.port;
        endpoints = [{
          name = "Website";
          group = "Portfolio";
          url = "https://aleksanderbl.dk";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 3000"
          ];
        }];
      };
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
