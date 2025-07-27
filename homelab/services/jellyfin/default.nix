{ config, lib, pkgs, ... }:
let
  cfg = config.homelab.services.jellyfin;
  homelab = config.homelab;
in
{
  options.homelab.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";

    url = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.${homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8096;
      description = "Port where Jellyfin is running";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "media";
      description = "User to run Jellyfin service as";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "media";
      description = "Group to run Jellyfin service as";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for Jellyfin";
    };

    hardwareAcceleration = {
      enable = lib.mkEnableOption "hardware acceleration for Jellyfin";

      intel = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Intel hardware acceleration (for Intel N100 and similar)";
      };
    };

    enableSkipIntroButton = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable skip intro button in Jellyfin web interface";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Jellyfin";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Media server and streaming platform";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "jellyfin.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Media";
    };
  };

  config = lib.mkIf cfg.enable {
    # Custom overlays for Jellyfin
    nixpkgs.overlays = lib.optionals cfg.hardwareAcceleration.intel [
      # Enable Intel hybrid codec support for hardware acceleration
      (final: prev: {
        vaapiIntel = prev.vaapiIntel.override { enableHybridCodec = true; };
      })
    ] ++ lib.optionals cfg.enableSkipIntroButton [
      # Add skip intro button to Jellyfin web interface
      (final: prev: {
        jellyfin-web = prev.jellyfin-web.overrideAttrs (
          finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          }
        );
      })
    ];

    # Hardware configuration for Intel graphics
    hardware = lib.mkIf cfg.hardwareAcceleration.intel {
      cpu.intel.updateMicrocode = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          vaapiVdpau
          intel-compute-runtime
          vpl-gpu-rt
        ];
      };
    };

    # Install Jellyfin packages
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    # Enable Jellyfin media server
    services.jellyfin = {
      enable = true;
      openFirewall = cfg.openFirewall;
      user = cfg.user;
      group = cfg.group;
    };

    # Caddy virtual host configuration for Jellyfin
    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port} {
          header_up X-Forwarded-Proto {scheme}
          header_up X-Forwarded-Host {host}
          header_up X-Forwarded-For {remote}
          header_up X-Real-IP {remote}
        }
      '';
    };
  };
}
