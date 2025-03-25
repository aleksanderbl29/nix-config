{
  pkgs,
  ...
}:
{
  imports = [
    ../common/shared/docker.nix
    ../../modules/ollama.nix
  ];

  modules.docker.enable = true;

  homebrew.casks = [
    "private-internet-access"
    "cursor"
  ];

  ids.gids.nixbld = 350;

  nix = {
    settings = {
      trusted-users = [ "aleksander" ];
    };
  };

  ollama = {
    enable = false;
    # launchAgent = true;
  };

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
    systemPackages = with pkgs; [
      cachix
    ];
  };
}
