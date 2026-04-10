{ ... }:
{
  homelab = {
    enable = true;
    baseDomain = "soundwave.aleksanderbl.dk";
    services = {
      labelstudio = {
        enable = true;
        labelStudioHost = "https://labelstudio.local.aleksanderbl.dk";
        trustedOrigins = [
          "https://labelstudio.soundwave.aleksanderbl.dk"
          "https://labelstudio.local.aleksanderbl.dk"
        ];
      };
      jellyfin = {
        enable = true;
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
      };
    };
  };
}
