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

  _module.args.username = "aleksander";

  system.stateVersion = 4;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    settings = {
      trusted-users = [ "aleksander" ];
    };
  };

  environment.variables = {
    LC_ALL = "da_DK.UTF-8";
    LANG = "da_DK.UTF-8";
  };

  services.tailscale.enable = lib.mkForce false;

  users.users.aleksander.home = "/Users/aleksander";

  programs.zsh.enable = true;

  nix.gc.automatic = true;

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
    ];
  };

  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    lmodern
    lmmath
  ];

  # services.nix-daemon.enable = true;

  # Following line should allow us to avoid a logout/login cycle
  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
