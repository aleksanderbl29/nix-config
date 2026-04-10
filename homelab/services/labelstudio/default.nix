{ config, lib, ... }:
let
  cfg = config.homelab.services.labelstudio;
  homelab = config.homelab;
in
{
  options.homelab.services.labelstudio = {
    enable = lib.mkEnableOption "Label Studio data labeling service";

    url = lib.mkOption {
      type = lib.types.str;
      default = "labelstudio.${homelab.baseDomain}";
      description = "URL where Label Studio will be accessible";
    };

    trustedOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "https://${cfg.url}" ];
      description = "Additional trusted origins for CSRF checks";
    };

    labelStudioHost = lib.mkOption {
      type = lib.types.str;
      default = "https://${cfg.url}";
      description = ''
        Public base URL embedded in HTML (static assets, redirects). Must match the
        hostname users open in the browser when you also reverse-proxy another name
        (e.g. set to https://labelstudio.local.… when that is the main URL).
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port where Label Studio listens";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/label-studio/data";
      description = "Host directory persisted to /label-studio/data";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Label Studio";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Data labeling platform for ML projects";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "https://raw.githubusercontent.com/heartexlabs/label-studio/master/docs/static/images/logo.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.labelstudio = {
      image = "heartexlabs/label-studio:latest";
      ports = [ "${toString cfg.port}:8080/tcp" ];
      volumes = [ "${cfg.dataDir}:/label-studio/data" ];
      environment = {
        LABEL_STUDIO_HOST = cfg.labelStudioHost;
        LABEL_STUDIO_PROXY = "true";
        CSRF_TRUSTED_ORIGINS = lib.concatStringsSep "," cfg.trustedOrigins;
      };
      extraOptions = [
        "--security-opt=no-new-privileges:true"
      ];
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };

    systemd.tmpfiles.rules = [
      # Label Studio runs as UID 1001 with GID 0 in the container.
      # Keep root ownership but allow group write so GID 0 can write the bind mount.
      "d ${cfg.dataDir} 0770 root root - -"
    ];
  };
}
