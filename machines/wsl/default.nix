{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./fixes.nix
  ]
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "aleksander"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };

  networking.networkmanager.enable = true;

  programs.zsh.enable = true;

  users.users.aleksander = {
    isNormalUser = true;
    description = "aleksander";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      zsh
      cmatrix
    ];
  };

  time.timeZone = "Europe/Copenhagen";
  # console.keyMap = "dk-latin1";

  # i18n = {
  #   # consoleFont = "Lat2-Terminus16";
  #   defaultLocale = "en_DK.UTF-8";
  #   # supportedLocales = [ "all" ];
  # };

  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    btop
    # ghostty
    inputs.my-nvf.packages.${system}.default
  ];
}
