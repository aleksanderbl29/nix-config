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
  };

  config = mkIf cfg.enable {
    systemd.services.beszel-agent = {
      description = "Beszel Agent Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = [
          "KEY=${cfg.key}"
          "EXTRA_FILESYSTEMS=${concatStringsSep "," cfg.extraFilesystems}"
          "PATH=/run/current-system/sw/bin:$PATH"
        ];
        ExecStart = "${pkgs.beszel}/bin/beszel-agent";
        User = cfg.user;
        Group = builtins.head cfg.groups;
        Restart = "always";
        RestartSec = cfg.restartSec;
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    environment.systemPackages = with pkgs; [
      beszel
    ];
  };
}
