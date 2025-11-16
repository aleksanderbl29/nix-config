{
  ...
}:
{

  imports = [
    ../../../modules/hyperhdr.nix
  ];

  services.hyperhdr = {
    enable = true;
    # configFile = ../dots/hyperhdr-config.json;
  };
}
