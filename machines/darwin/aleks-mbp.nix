{
  pkgs,
  inputs,
  ...
}:
let
  ai-tools = inputs.nix-ai-tools.packages.${pkgs.system};
in
{
  imports = [
    ../common/shared/docker.nix
    ../../modules/ollama.nix
  ];

  modules.docker.enable = true;

  homebrew = {
    casks = [
      "private-internet-access"
      "conductor"
      "cursor"
      "makemkv"
      "linear-linear"
      # "gcloud-cli"
      "tad"
      "quarto"
    ];
    brews = [
      "node"
      "pnpm"
      "uv"
      "cmake"
      "abseil"
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
    systemPackages = with pkgs; [
      cachix
      air-formatter
      ai-tools.cursor-agent
      ai-tools.claude-code
    ];
  };
}
