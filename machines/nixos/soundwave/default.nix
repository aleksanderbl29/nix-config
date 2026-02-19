{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./homelab.nix
    # ./samba.nix
    ./disko-config.nix
    ../../../modules/beszel-agent.nix
  ];

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

  users = {
    users = {
      aleksander = {
        isNormalUser = true;
        description = "aleksander";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
      };
      media = {
        isSystemUser = true;
        description = "media";
        extraGroups = [
          "media"
        ];
        group = "media";
      };
    };
    groups = {
      media = { };
    };
  };

  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.system}; [
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  system.stateVersion = "24.11";

  # programs.nix-ld.enable = true;

  zramSwap.enable = true;
}
