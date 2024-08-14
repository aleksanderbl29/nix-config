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
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.aleksanderbang-larsen.home = "/Users/aleksanderbang-larsen";

  programs.zsh.enable = true;

  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    systemPackages = with pkgs; [
      coreutils
      git
      vim
    ];
  };

  # system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];

  services.nix-daemon.enable = true;

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}