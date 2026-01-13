{ config, lib, ... }:
let
  cfg = config.homelab.services.webcheck;
  homelab = config.homelab;
in
{
  options.homelab.services.webcheck = {
    enable = lib.mkEnableOption "WebCheck security and privacy scanner";

    url = lib.mkOption {
      type = lib.types.str;
      default = "webcheck.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3003;
      description = "External port where WebCheck is accessible";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "WebCheck";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Security and privacy scanner for websites";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/Lissy93/web-check/blob/master/.github/web-check-logo.png?raw=true";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.webcheck = {
      image = "lissy93/web-check:latest";
      ports = [
        "${toString cfg.port}:3000/tcp"
      ];
      extraOptions = [
        "--security-opt=no-new-privileges:true"
      ];
      environment = {
        PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium";
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
