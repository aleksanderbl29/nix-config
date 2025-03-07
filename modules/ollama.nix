{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ollama;
in
{
  options.ollama = {
    enable = lib.mkEnableOption "Local ollama installation with open-webui";
    launchAgent = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable ollama launch agent";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ollama
      open-webui
    ];

    # this code is attributed to https://www.danielcorin.com/til/nix-darwin/launch-agents/
    launchd = lib.mkIf cfg.launchAgent {
      user = {
        agents = {
          ollama-serve = {
            command = "${pkgs.ollama}/bin/ollama serve";
            serviceConfig = {
              KeepAlive = true;
              RunAtLoad = true;
              StandardOutPath = "/tmp/ollama_aleksander.out.log";
              StandardErrorPath = "/tmp/ollama_aleksander.err.log";
            };
          };
        };
      };
    };
  };
}
