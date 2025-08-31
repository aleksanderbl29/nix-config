{ config, lib, ... }:
let
  cfg = config.homelab.services.karakeep;
  homelab = config.homelab;
in
{
  options.homelab.services.karakeep = {
    enable = lib.mkEnableOption "Karakeep bookmark management service";

    url = lib.mkOption {
      type = lib.types.str;
      default = "bookmarks.local.aleksanderbl.dk";
      description = "URL where Karakeep will be accessible";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port where Karakeep will be accessible";
    };

    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Bookmarks";
    };

    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "AI-powered bookmark management with automatic tagging";
    };

    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "sh-karakeep.svg";
    };

    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "Services";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create necessary directories
    systemd.tmpfiles.rules = [
      "d /var/lib/karakeep 0750 karakeep karakeep - -"
      "d /var/lib/karakeep/storage 0750 karakeep karakeep - -"
    ];

    # Ensure karakeep user is in the homelab group for proper integration
    users.users.karakeep.extraGroups = [ homelab.group ];
  };
}
