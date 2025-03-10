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
    # useOSProber = true;
  };

  networking = {
    hostName = "k3s-2";
    networkmanager.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  system.stateVersion = "24.11";
}
