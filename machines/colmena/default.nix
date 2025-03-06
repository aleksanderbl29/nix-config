{
  config,
  ...
}:
{
  imports = [
    ../nixos
  ];
  deployment.targetHost = config.networking.hostName;
  deployment = {
    targetUser = "root";
    buildOnTarget = true;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.aleksander = {
    imports = [ ../../home ];
  };
}
