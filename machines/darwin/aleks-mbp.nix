{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../common/shared/docker.nix
    ../../modules/ollama.nix
  ];

  modules.docker.enable = true;

  homebrew = {
    casks = [
      "private-internet-access"
      "cursor"
      "cursor-cli"
      "codex"
      "makemkv"
      # "linear-linear"
      # "gcloud-cli"
      "tad"
      "quarto"
      "radiola"
      "positron"

      # needed for hammerspoon configured in home/aleks-mbp.nix
      "hammerspoon"
    ];
    brews = [
      "node"
      "pnpm"
      "uv"
      "cmake"
      "abseil"
      "udunits"
      "pkg-config"
      "proj"
      "gdal"
      "geos"
      "udunits"
      "expat"
      "libgit2"
    ];
  };

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
    variables = {
      QUARTO_R = "/opt/homebrew/bin/R";
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      cachix
      air-formatter
    ];
  };
}
