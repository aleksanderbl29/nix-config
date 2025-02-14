{lib, ...}: let
  user = "aleksander";
in {
  nix = {
    settings = {
      trusted-users = [user];
    };
  };

  homebrew = {
    # masApps = {

    # };
    casks = [
      "home-assistant"
    ];
    brews = [
      "btop"
    ];
  };

  environment = {
    systemPath = ["/opt/homebrew/bin"];
  };

  nix-homebrew = {
    enableRosetta = lib.mkForce false;
  };
}
