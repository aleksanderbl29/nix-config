{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.ersatztv;
  homelab = config.homelab;
in
{
  options.homelab.services.ersatztv = {
    enable = lib.mkEnableOption "ErsatzTV custom live TV server";

    url = lib.mkOption {
      type = lib.types.str;
      default = "tv.${homelab.baseDomain}";
      description = "Hostname where ErsatzTV is accessible";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8409;
      description = "Host port where ErsatzTV listens";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "ErsatzTV";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Custom live TV channels from Jellyfin media";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "ersatztv.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.homelab.services.jellyfin.enable;
        message = "homelab.services.ersatztv requires the Jellyfin service to be enabled.";
      }
    ];

    services.ersatztv = {
      enable = true;
      environment = {
        ETV_UI_PORT = cfg.port;
        TZ = homelab.timeZone;
      };
    };

    # Allow direct playback from the same media paths used by Jellyfin and
    # hardware-accelerated transcoding through the Intel GPU.
    systemd.services.ersatztv.serviceConfig.SupplementaryGroups = [
      "media"
      "render"
      "video"
    ];
    systemd.services.ersatztv.path = [
      pkgs.bash
      pkgs.libva-utils
    ];

    services.caddy.virtualHosts."${cfg.url}".extraConfig = ''
      tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
      reverse_proxy http://127.0.0.1:${toString cfg.port}
    '';
  };
}
