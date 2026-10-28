{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.services.t3code;
  homelab = config.homelab;
  home = config.users.users.${cfg.user}.home;
in
{
  options.homelab.services.t3code = {
    enable = lib.mkEnableOption "T3 Code remote coding environment";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.t3code;
      description = "T3 Code server package.";
    };
    user = lib.mkOption {
      type = lib.types.str;
      description = "Existing user whose home and T3 credentials the server uses.";
    };
    codexAgentsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = ./codex-agents.md;
      defaultText = lib.literalExpression "./codex-agents.md";
      description = "Markdown file to install as the user's global Codex AGENTS.md.";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "t3code.${homelab.baseDomain}";
      description = "Caddy hostname for T3 Code, kept private on the tailnet.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3773;
      description = "Local port used by the T3 Code server and Caddy.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    home-manager.users.${cfg.user}.home.file = lib.mkIf (cfg.codexAgentsFile != null) {
      ".codex/AGENTS.md".source = cfg.codexAgentsFile;
    };

    systemd.services.t3code = {
      description = "T3 Code remote coding environment";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        HOME = home;
        # T3 downloads Chrome for Testing, which needs an explicit library path on NixOS.
        LD_LIBRARY_PATH = lib.makeLibraryPath [
          pkgs.glib
          pkgs.nspr
          pkgs.nss
          pkgs.at-spi2-core
          pkgs.dbus
          pkgs.libX11
          pkgs.libXcomposite
          pkgs.libXdamage
          pkgs.libXext
          pkgs.libXfixes
          pkgs.libXrandr
          pkgs.libgbm
          pkgs.expat
          pkgs.libxcb
          pkgs.libxkbcommon
          pkgs.systemd
          pkgs.alsa-lib
        ];
      };
      script = ''
        exec ${lib.getExe cfg.package} serve \
          --host 127.0.0.1 \
          --port ${toString cfg.port} \
          --no-browser
      '';
      serviceConfig = {
        User = cfg.user;
        WorkingDirectory = home;
        Restart = "always";
        RestartSec = 10;
        UMask = "0077";
      };
    };

    services.caddy.virtualHosts.${cfg.url} = {
      extraConfig = ''
        tls ${homelab.tls.certFile} ${homelab.tls.keyFile}
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
