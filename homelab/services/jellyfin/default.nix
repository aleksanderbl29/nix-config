{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.jellyfin;
  homelab = config.homelab;
  jellarrLibraryPaths =
    let
      virtualFolders =
        if cfg.jellarr.config ? library && cfg.jellarr.config.library ? virtualFolders then
          cfg.jellarr.config.library.virtualFolders
        else
          [ ];
    in
    lib.flatten (
      map (folder: map (pathInfo: pathInfo.path) (folder.libraryOptions.pathInfos or [ ])) virtualFolders
    );
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

    jellarr = {
      enable = lib.mkEnableOption "Jellarr synchronization for Jellyfin";

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Systemd environment file containing JELLARR_API_KEY.";
      };

      config = lib.mkOption {
        type = lib.types.attrs;
        default = import ./config.nix;
        description = "Jellarr configuration as a Nix attrset.";
      };

      baseUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:${toString cfg.port}";
        description = "Jellyfin base URL used by Jellarr API calls.";
      };

      runOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Run Jellarr once at boot via jellarr.service.";
      };

      schedule = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Optional OnCalendar schedule for periodic Jellarr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.optionals cfg.jellarr.enable [
      {
        assertion = cfg.jellarr.environmentFile != null;
        message = "homelab.services.jellyfin.jellarr.environmentFile must be set when Jellarr is enabled.";
      }
    ];

    # Custom overlays for Jellyfin
    nixpkgs.overlays =
      lib.optionals cfg.hardwareAcceleration.intel [
        # Enable Intel hybrid codec support for hardware acceleration
        (_: prev: {
          vaapiIntel = prev.vaapiIntel.override { enableHybridCodec = true; };
        })
      ]
      ++ lib.optionals cfg.enableSkipIntroButton [
        # Add skip intro button to Jellyfin web interface
        (_: prev: {
          jellyfin-web = prev.jellyfin-web.overrideAttrs (
            _: _: {
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
          libva-vdpau-driver
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

    services.jellarr = lib.mkIf cfg.jellarr.enable (
      {
        enable = true;
        environmentFile = cfg.jellarr.environmentFile;
        config = cfg.jellarr.config // {
          base_url = cfg.jellarr.baseUrl;
        };
      }
      // lib.optionalAttrs (cfg.jellarr.schedule != null) {
        schedule = cfg.jellarr.schedule;
      }
    );

    # Expand environment variables inside the generated YAML config so
    # secrets can come from environmentFile at runtime.
    systemd.services.jellarr.preStart = lib.mkIf cfg.jellarr.enable (
      lib.mkAfter ''
        tmp_cfg="$(${pkgs.coreutils}/bin/mktemp)"
        ${pkgs.gettext}/bin/envsubst < ${config.services.jellarr.dataDir}/config/config.yml > "$tmp_cfg"
        ${pkgs.coreutils}/bin/install -m 0644 "$tmp_cfg" ${config.services.jellarr.dataDir}/config/config.yml
        ${pkgs.coreutils}/bin/chown ${config.services.jellarr.user}:${config.services.jellarr.group} ${config.services.jellarr.dataDir}/config/config.yml
        ${pkgs.coreutils}/bin/rm -f "$tmp_cfg"

        echo "Jellarr preflight: validating library paths from config"
        missing_paths=0
        for library_path in ${lib.concatStringsSep " " (map lib.escapeShellArg jellarrLibraryPaths)}; do
          if [ -d "$library_path" ]; then
            echo "Jellarr preflight: library path exists: $library_path"
          else
            echo "Jellarr preflight: missing library path: $library_path"
            missing_paths=1
          fi
        done

        if [ "$missing_paths" -ne 0 ]; then
          echo "Jellarr preflight: one or more library paths are missing; aborting before apply."
          exit 1
        fi
      ''
    );

    systemd.services.jellarr.wantedBy = lib.mkIf (cfg.jellarr.enable && cfg.jellarr.runOnBoot) [
      "multi-user.target"
    ];

    systemd.timers.jellarr.enable = lib.mkIf (cfg.jellarr.enable && cfg.jellarr.schedule == null) false;

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
