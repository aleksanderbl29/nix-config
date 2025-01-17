# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Add any kernel modules or parameters here if needed
    # kernelModules = [ ];
  };

  # Network configuration
  networking = {
    hostName = "nixos-machine"; # Define your hostname
    networkmanager.enable = true; # Enable networking
    # Configure network proxy if necessary
    # proxy.default = "http://proxy:8080";
  };

  # Set your time zone
  time.timeZone = "America/New_York";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account
  users.users.myuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable 'sudo' for the user
    initialPassword = "changeme";
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    # Basic utilities
    vim
    wget
    git
    curl

    # System tools
    htop
    tmux
    tree

    # Development
    gcc
    gnumake
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon
    openssh = {
      enable = true;
      # Optionally configure SSH settings
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    # Enable CUPS to print documents
    printing.enable = true;

    # Enable the X11 windowing system
    xserver = {
      enable = true;
      layout = "us";

      # Enable the GNOME Desktop Environment
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  # Configure system-wide environment variables
  environment.variables = {
    EDITOR = "vim";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable automatic system upgrades
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;  # Set to true if you want automatic reboots
  };

  # Enable automatic garbage collection
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Security settings
  security = {
    sudo.wheelNeedsPassword = true;  # Require password for sudo
    # Enable PAM
    pam.enableSSHAgentAuth = true;
  };

  # Firewall settings
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
    # allowedUDPPorts = [ ... ];
  };
}