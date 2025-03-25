{
  config,
  lib,
  ...
}:

let
  cfg = config.docker.beszel-hub;
in
{
  options.docker.beszel-hub = with lib; {
    enable = mkEnableOption "Beszel Hub service" // {
      default = false;
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/beszel";
      description = "Directory to store Beszel data";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure data directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root - -"
    ];

    # Configure Docker container
    virtualisation.oci-containers = {
      containers = {
        beszel = {
          image = "henrygd/beszel";
          ports = [
            "8090:8090"
          ];
          volumes = [
            "beszel_data:/beszel_data"
          ];
        };
      };
    };
  };
}
