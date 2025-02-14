{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [];

  options.modules.docker = with lib; {
    enable = mkEnableOption "docker support";
  };

  config = lib.mkIf config.modules.docker.enable {
    homebrew = lib.mkIf pkgs.stdenv.isDarwin {
      enable = true;
      casks = ["docker"];
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
