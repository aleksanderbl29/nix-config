{
  config,
  ...
}:
{
  imports = [
    ../nixos
  ];
  deployment = {
    targetHost = config.networking.hostName;
    targetUser = "root";
    buildOnTarget = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aleksander = {
      imports = [ ../../home ];
    };
  };
}
