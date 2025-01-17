{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./homebrew.nix
    ./system.nix
    ./dock.nix
  ];

  system.stateVersion = 4;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    settings = {
      trusted-users = [ "aleksanderbang-larsen" ];
    };
  };

  environment.variables = {
    LC_ALL = "da_DK.UTF-8";
    LANG = "da_DK.UTF-8";
  };

  users.users.aleksanderbang-larsen.home = "/Users/aleksanderbang-larsen";

  programs.zsh.enable = true;

  nix.gc.automatic = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "aleksanderbang-larsen";
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/services" = inputs.homebrew-services;
      "hudochenkov/homebrew-sshpass" = inputs.homebrew-sshpass;
      "teamookla/homebrew-speedtest" = inputs.homebrew-speedtest;
    };
  };

  environment = {
    pathsToLink = [ "/Applications" ];
    systemPackages = with pkgs; [
      coreutils
      git
      vim
      ncdu
    ];
  };

  # system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    lmodern
    lmmath
  ];

  services.nix-daemon.enable = true;

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}