{ ... }:
let
  user = "aleksander";
in
{
  imports = [
    ../common/shared/docker.nix
  ];

  modules.docker.enable = true;

  nix = {
    settings = {
      trusted-users = [ user ];
    };
  };

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };
}