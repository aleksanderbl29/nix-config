{
  config,
  ...
}:
let
  homelab = config.homelab;
in
{
  homelab = {
    enable = true;
    services = {
      jellyfin = {
        enable = true;
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
        url = "soundwave-jellyfin.${homelab.baseDomain}";
      };
    };
  };
}
