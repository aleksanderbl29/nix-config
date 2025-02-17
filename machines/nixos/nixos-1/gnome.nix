{pkgs, ...}: {
  # minimized for clarity.
  # Some of these might not be needed. After some trial and error
  # I got this working with these configs.
  # I do not have the patience to rn an elimination test.

  services.gnome.gnome-remote-desktop.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  environment.systemPackages = with pkgs; [
    gnome-session
  ];

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [3389];
    allowedUDPPorts = [3389];
  };
}
