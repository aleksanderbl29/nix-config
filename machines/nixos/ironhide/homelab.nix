{
  config,
  ...
}:
let
  hl = config.homelab;
in
{
  homelab = {
    enable = true;
    services = {
      homepage = {
        enable = true;
      };
      jellyfin = {
        enable = true;
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
      };
    };
  };

  # Additional homelab services that aren't part of the main homelab module
  services.open-webui = {
    enable = true;
    port = 8080;
    host = "0.0.0.0";
    openFirewall = true;
  };

  services.litellm = {
    enable = true;
  };
}
