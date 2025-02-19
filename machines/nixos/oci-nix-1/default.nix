{ ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "oci-nix-1-955108";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK9tIBN3zPPeUkBbXuXqx/618JPndC9OVr6nvKyqYaA aleksander@aleks-mbp.local'' ];
  system.stateVersion = "23.11";
}
