{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ./dock.nix
    ../../common/darwin/spotify-notifications.nix
  ];

  nix.enable = false;

  _module.args.username = "aleksander";

  system.primaryUser = "aleksander";

  system.stateVersion = 4;
  environment.variables = {
    LC_ALL = "da_DK.UTF-8";
    LANG = "da_DK.UTF-8";
  };

  services.tailscale.enable = lib.mkForce false;

  users.users.aleksander.home = "/Users/aleksander";

  programs.zsh.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "aleksander";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/homebrew-services" = inputs.homebrew-services;
      # "aleksanderbl29/homebrew-cask" = inputs.personal-homebrew;
    };
  };

  environment = {
    pathsToLink = [ "/Applications" ];
    systemPackages = with pkgs; [
      coreutils
      git
      ncdu
      spotify
      parsedmarc
    ];
  };

  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    lmodern
    lmmath
  ];
}
