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
      # neovim
      #  thunderbird
    ];
  };

  # Basic system-wide settings that should apply to all NixOS machines
  time.timeZone = "Europe/Copenhagen";

  # Default locale settings
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    wget
    # neovim
    htop
    ghostty
    # inputs.my-nvf.packages.${system}.default
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpoAMN4OFauCaNhOID7WbTLlo5F72qcKONB8y8T3IQrXxynwafZmXWdAsyw3TFci6P0WYyEQQQoSnWo7NaUxdSPz0GHa1RHzgfhq00N+xCgMIBIRe3WFK2nnlf5GA3QZ0Pq6EaLjTj36XoGCVPBA+HHn8xqmnIbq/yb1neLrNT0dtsR7DDxchFr574g7SyEMnpNmLJBrK6Uw4iFLKkpFYuAs0i/cWU6DhjRJh4dxkHhYXylvMAcdmEl8rSbPBad9hWUtvhrNjVxu8KLIzcvr8FVbocx2C/8wnZUOEqCWQYK+IYckq+Yi60a72wCFd852QLCC45yLKZ/fNf0HsuWl66zd/we90afqACISZ1cckTyxAq+QU3wah6ypBvpae9SfVnxRC3cpB6tXX+2vkrAMIUA4CWqBtGS96bFc21GLT5wbh/RdZBaiqzP1scIIgf09TFgO/qBlZUZrdkwqK1nKLydUWXpg+jBVdgS5ehITbIDJKWilQmXITQ3O+HFmWckm8= aleksander@aleks-mbp.local
"
  ];
}
