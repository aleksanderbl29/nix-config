{
  ...
}:
{
  homelab = {
    enable = true;
    services = {
      jellyfin = {
        enable = true;
        hardwareAcceleration.intel = true;
        enableSkipIntroButton = true;
      };
    };
  };
}
