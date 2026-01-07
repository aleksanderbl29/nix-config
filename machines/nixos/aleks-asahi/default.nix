{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.nixos-asahi.nixosModules.apple-silicon-support
    ];

  hardware.asahi.setupAsahiSound = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  time.timeZone = "Europe/Copenhagen";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  networking = {
    hostName = "aleks-asahi";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless = {
      iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
      };
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  console.keyMap = "dk-latin1";

  users.users.aleksander = {
    isNormalUser = true;
    description = "aleksander";
    initialPassword = "adgangskode";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    ghostty
    git
    gh
    vscode-fhs
    yazi
  ];

  programs.firefox.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Do not change this unless you know what you are doing!
  system.stateVersion = "25.11"; # Did you read the comment?

}

