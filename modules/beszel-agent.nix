# modules/beszel-agent.nix
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.beszel-agent;
in
{
  options.services.beszel-agent = {
    enable = mkEnableOption "Beszel agent service";

    port = mkOption {
      type = types.port;
      default = 45876;
      description = "Port number for the beszel agent to listen on.";
    };

    key = mkOption {
      type = types.str;
      default = "\"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZ5KOjxmMf0QPHln20mOGXxN2QG6yP8pZgKUFyMymTV\"";
      description = "SSH key for the beszel agent.";
    };

    extraFilesystems = mkOption {
      type = types.listOf types.str;
      default = [ "/" ];
      description = "List of additional filesystems to monitor.";
    };

    user = mkOption {
      type = types.str;
      default = "root";
      description = "User account under which the service runs.";
    };

    groups = mkOption {
      type = types.listOf types.str;
      default = [ "root" ];
      description = "Groups under which the service runs.";
    };

    restartSec = mkOption {
      type = types.int;
      default = 5;
      description = "Time to wait before restarting the service.";
    };

    gpu = mkOption {
      type = types.bool;
      default = false;
      description = "Sets env var to enable GPU monitoring.";
    };

    smartData = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable S.M.A.R.T. disk monitoring via smartctl.
        Installs smartmontools and grants the agent CAP_SYS_RAWIO / CAP_SYS_ADMIN
        (required for SATA and NVMe respectively). See https://beszel.dev/guide/smart-data
      '';
    };
  };

  config = mkIf cfg.enable {
    # SCSI generic: needed for smartctl on SATA/ATA (ironhide); harmless on NVMe.
    boot.kernelModules = mkIf cfg.smartData [ "sg" ];

    systemd.services.beszel-agent = {
      description = "Beszel Agent Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = [
          "KEY=${cfg.key}"
          "EXTRA_FILESYSTEMS=${concatStringsSep "," cfg.extraFilesystems}"
          "PATH=${makeBinPath (optionals cfg.smartData [ pkgs.smartmontools ])}:/run/current-system/sw/bin"
        ]
        ++ optional cfg.gpu "GPU=true";
        ExecStart = "${pkgs.beszel}/bin/beszel-agent";
        User = cfg.user;
        Group = builtins.head cfg.groups;
        Restart = "always";
        RestartSec = cfg.restartSec;
      }
      // optionalAttrs cfg.smartData {
        # SATA/ATA via SG_IO needs CAP_SYS_RAWIO; NVMe admin passthrough needs CAP_SYS_ADMIN.
        # AmbientCapabilities is enough when running as root; needed if user is ever dropped.
        AmbientCapabilities = "CAP_SYS_RAWIO CAP_SYS_ADMIN";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    environment.systemPackages =
      with pkgs;
      [
        beszel
      ]
      ++ optional cfg.smartData smartmontools;
  };
}
