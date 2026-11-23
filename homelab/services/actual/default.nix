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
      description = "HTTPS hostname, accessible only from the tailnet.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5006;
      description = "Loopback port used by the server and Caddy.";
    };

    homepage = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Actual Budget";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Local-first budgeting and expense tracking";
      };
      icon = lib.mkOption {
        type = lib.types.str;
        default = "actual-budget.svg";
      };
      category = lib.mkOption {
        type = lib.types.str;
        default = "Services";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (homelab.publicExpose.actual or false) == false;
        message = "Actual Budget must remain private to the tailnet.";
      }
    ];

    services.actual = {
      enable = true;
      openFirewall = false;
      settings = {
        hostname = "127.0.0.1";
        port = cfg.port;
      };
    };

    services.caddy.virtualHosts.${cfg.url}.extraConfig = ''
      tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
      # Match the direct peer, never a client-supplied forwarding header.
      @tailnet remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48
      handle @tailnet {
        header {
          Cross-Origin-Opener-Policy same-origin
          Cross-Origin-Embedder-Policy require-corp
        }
        reverse_proxy 127.0.0.1:${toString cfg.port}
      }
      handle {
        respond "Tailnet access only" 403
      }
    '';
  };
}
