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
      littlelink = {
        enable = true;
      };
      karakeep = {
        enable = true;
      };
      beszel = {
        enable = true;
      };
      forgejo = {
        enable = true;
        proxyUrl = "git.aleksanderbl.dk";
      };
      webcheck = {
        enable = true;
      };
      umami = {
        enable = true;
      };
    };
    remoteProxies = {
      labelstudio = {
        machine = "soundwave";
        service = "labelstudio";
      };
      "soundwave-jellyfin" = {
        machine = "soundwave";
        service = "jellyfin";
      };
    };
  };
}
