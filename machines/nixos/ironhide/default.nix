{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./homelab.nix
    ./jellyfin.nix
    ./samba.nix
    ../../../modules/docker
    ../../../modules/beszel-agent.nix
  ];

  # Enable homelab services
  homelab.services = {
    # beszel.enable = true;  # Disabled for now
    littlelink.enable = true;
  };

  # Disabled for now - having configuration issues
  # services.beszel-agent = {
  #   enable = true;
  #   port = 45876;
  #   key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8DxcwL0d1IFe5ILwczYXLM4YF6xLGxJBL8lTR6MUGf";
  # };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  users.users.aleksander = {
    isNormalUser = true;
    description = "aleksander";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
