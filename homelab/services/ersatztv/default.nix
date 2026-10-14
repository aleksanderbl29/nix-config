{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.ersatztv;
  homelab = config.homelab;

  # ErsatzTV's build carries patches that are not part of stock FFmpeg (in
  # particular fixes for VAAPI/QSV pipelines). Keep this in sync with the
  # version expected by the ErsatzTV health check.
  ersatztv-ffmpeg = pkgs.stdenvNoCC.mkDerivation {
    pname = "ersatztv-ffmpeg";
    version = "8.1.2-etv.4";

    src = pkgs.fetchurl {
      url = "https://github.com/ErsatzTV/ErsatzTV-ffmpeg/releases/download/8.1.2-4/ffmpeg-n8.1.2-etv.4-linux64-gpl-8.1.tar.xz";
      hash = "sha256-/Upgsu92G6fw+mrWkXWzC3IWxYjsqbMUDmObAqgbNwk=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r bin doc man presets LICENSE.txt "$out/"
      runHook postInstall
    '';

    meta = {
      description = "FFmpeg build patched and tested for ErsatzTV";
      homepage = "https://github.com/ErsatzTV/ErsatzTV-ffmpeg";
      license = lib.licenses.gpl3Plus;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
{
  options.homelab.services.ersatztv = {
    enable = lib.mkEnableOption "ErsatzTV custom live TV server";

    url = lib.mkOption {
      type = lib.types.str;
      default = "ersatz.${homelab.baseDomain}";
      description = "Hostname where ErsatzTV is accessible";
    };

    iptvUrl = lib.mkOption {
      type = lib.types.str;
      default = "tv.${homelab.baseDomain}";
      description = "Hostname serving ErsatzTV's IPTV playlist, guide, and streams";
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
      package = pkgs.ersatztv.override { ffmpeg = ersatztv-ffmpeg; };
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

    # ErsatzTV persists absolute tool paths in its database and prefers them
    # over PATH. Keep those settings aligned with the package selected above.
    # A new database needs no update because ErsatzTV discovers both tools
    # from PATH during its first startup.
    systemd.services.ersatztv.preStart = lib.mkBefore ''
      database="$ETV_CONFIG_FOLDER/ersatztv.sqlite3"
      if [ -f "$database" ]; then
        ${pkgs.sqlite}/bin/sqlite3 "$database" \
          "INSERT INTO ConfigElement (\"Key\", \"Value\") VALUES ('ffmpeg.ffmpeg_path', '${ersatztv-ffmpeg}/bin/ffmpeg') ON CONFLICT(\"Key\") DO UPDATE SET \"Value\" = excluded.\"Value\";"
        ${pkgs.sqlite}/bin/sqlite3 "$database" \
          "INSERT INTO ConfigElement (\"Key\", \"Value\") VALUES ('ffmpeg.ffprobe_path', '${ersatztv-ffmpeg}/bin/ffprobe') ON CONFLICT(\"Key\") DO UPDATE SET \"Value\" = excluded.\"Value\";"
      fi
    '';

    systemd.services.ersatztv.path = [
      pkgs.bash
      ersatztv-ffmpeg
      pkgs.libva-utils
    ];

    services.caddy.virtualHosts = {
      "${cfg.url}".extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';

      "${cfg.iptvUrl}".extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        redir / /iptv/channels.m3u
        handle /iptv/* {
          reverse_proxy http://127.0.0.1:${toString cfg.port}
        }
        respond 404
      '';
    };
  };
}
