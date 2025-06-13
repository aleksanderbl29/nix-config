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
      open-webui = {
        enable = true;
        port = 8080;
      };
    };
  };
}
