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
        jellarr.enable = true;
        jellarr.environmentFile = "/var/lib/jellyfin/jellarr.env";
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
      };
    };
  };
}
