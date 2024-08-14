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
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };

  # system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];

  services.nix-daemon.enable = true;
}