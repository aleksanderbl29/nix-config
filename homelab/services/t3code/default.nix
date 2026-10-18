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

    systemd.services.t3code = {
      description = "T3 Code remote coding environment";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment.HOME = home;
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
