{
  pkgs,
  inputs,
  ...
}:
{
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
    ];
  };

  time.timeZone = "Europe/Copenhagen";
  console.keyMap = "dk";

  i18n = {
    # consoleFont = "Lat2-Terminus16";
    i18n.defaultLocale = "en_DK.UTF-8";
    # supportedLocales = [ "all" ];
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    htop
    btop
    ghostty
    inputs.my-nvf.packages.${system}.default
  ];

  services.tailscale.enable = true;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpoAMN4OFauCaNhOID7WbTLlo5F72qcKONB8y8T3IQrXxynwafZmXWdAsyw3TFci6P0WYyEQQQoSnWo7NaUxdSPz0GHa1RHzgfhq00N+xCgMIBIRe3WFK2nnlf5GA3QZ0Pq6EaLjTj36XoGCVPBA+HHn8xqmnIbq/yb1neLrNT0dtsR7DDxchFr574g7SyEMnpNmLJBrK6Uw4iFLKkpFYuAs0i/cWU6DhjRJh4dxkHhYXylvMAcdmEl8rSbPBad9hWUtvhrNjVxu8KLIzcvr8FVbocx2C/8wnZUOEqCWQYK+IYckq+Yi60a72wCFd852QLCC45yLKZ/fNf0HsuWl66zd/we90afqACISZ1cckTyxAq+QU3wah6ypBvpae9SfVnxRC3cpB6tXX+2vkrAMIUA4CWqBtGS96bFc21GLT5wbh/RdZBaiqzP1scIIgf09TFgO/qBlZUZrdkwqK1nKLydUWXpg+jBVdgS5ehITbIDJKWilQmXITQ3O+HFmWckm8= aleksander@aleks-mbp.local
"
  ];
}
