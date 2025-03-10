{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/shared/tailscale.nix
    ../../common/shared/k3s.nix
  ];

  services.qemuGuest.enable = true;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  networking = {
    hostName = "k3s-1";
    networkmanager.enable = true;
  };

  system.stateVersion = "24.11";
}
