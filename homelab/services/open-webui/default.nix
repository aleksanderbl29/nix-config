{ lib, config, ... }:
let
  cfg = config.homelab.services.open-webui;
  homelab = config.homelab;
in
{
  options.homelab.services.open-webui = {
    enable = lib.mkEnableOption "Open WebUI service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to run the service on";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "open-webui.${homelab.baseDomain}";
      description = "URL for the service";
    };
    homepage.name = lib.mkOption {
      type = lib.types.str;
      default = "Open WebUI";
      description = "Name to display in homepage";
    };
    homepage.description = lib.mkOption {
      type = lib.types.str;
      default = "Open WebUI for Ollama";
      description = "Description to display in homepage";
    };
    homepage.icon = lib.mkOption {
      type = lib.types.str;
      default = "open-webui.svg";
      description = "Icon to display in homepage";
    };
    homepage.category = lib.mkOption {
      type = lib.types.str;
      default = "AI";
      description = "Category to display in homepage";
    };
  };

  config = lib.mkIf cfg.enable {
    # Service-specific configuration goes here
    # For example:
    # services.open-webui = {
    #   enable = true;
    #   port = cfg.port;
    # };

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = homelab.baseDomain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
