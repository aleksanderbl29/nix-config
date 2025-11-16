{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hyperhdr;
in
{
  options.services.hyperhdr = {
    enable = lib.mkEnableOption "HyperHDR service";
    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the HyperHDR configuration file";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hyperhdr
    ];

    systemd.services.hyperhdr = {
      description = "HyperHDR service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hyperhdr}/bin/hyperhdr -c ${cfg.configFile}";
        Restart = "always";
        RestartSec = 5;
      };
      unitConfig = {
        ConditionPathExists = cfg.configFile;
      };
    };
  };
}
