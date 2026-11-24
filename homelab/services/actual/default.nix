{ config, lib, ... }:
let
  cfg = config.homelab.services.actual;
  homelab = config.homelab;
in
{
  options.homelab.services.actual = {
    enable = lib.mkEnableOption "Actual Budget";

    url = lib.mkOption {
      type = lib.types.str;
      default = "actual.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5006;
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Actual Budget";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Personal budgeting";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "actual-budget.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    services.actual = {
      enable = true;
      settings = {
        hostname = "127.0.0.1";
        port = cfg.port;
      };
    };

    services.caddy.virtualHosts."${cfg.url}".extraConfig = ''
      tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
      reverse_proxy http://127.0.0.1:${toString cfg.port}
    '';
  };
}
