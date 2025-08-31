{
  ...
}:
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
      immich = {
        enable = true;
      };
      littlelink = {
        enable = true;
      };
      karakeep = {
        enable = true;
      };
    };
  };
}
