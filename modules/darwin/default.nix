{
  pkgs,
  ...
}: {
  imports = [
    ./homebrew.nix
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
      allowUnfree = true;
    };
  };

  environment.variables = {
    LC_ALL = "da_DK.UTF-8";
    LANG = "da_DK.UTF-8";
  };

  users.users.aleksanderbang-larsen.home = "/Users/aleksanderbang-larsen";

  programs.zsh.enable = true;

  nix.gc.automatic = true;

  environment = {
    shells = with pkgs; [ bash zsh ];
    systemPath = [ "/opt/homebrew/bin" ];
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
  ];

  services.nix-daemon.enable = true;

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}