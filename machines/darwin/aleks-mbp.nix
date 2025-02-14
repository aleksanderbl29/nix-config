{...}: let
  user = "aleksander";
in {
  imports = [
    ../common/shared/docker.nix
  ];

  modules.docker.enable = true;

  ids.gids.nixbld = 350;

  nix = {
    settings = {
      trusted-users = [user];
    };
  };

  environment = {
    systemPath = ["/opt/homebrew/bin"];
  };
}
