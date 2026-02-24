{ ... }:
{
  homelab = {
    enable = true;
    baseDomain = "soundwave.aleksanderbl.dk";
    services = {
      jellyfin = {
        enable = true;
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
      };
    };
  };
}
