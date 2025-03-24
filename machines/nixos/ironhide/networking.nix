{ config, pkgs, ... }:

{
  networking = {
    hostName = "ironhide";
    networkmanager.enable = true;
    # Configure base network interface
    interfaces = {
      enp1s0 = {
        useDHCP = true;
      };
      vlan20 = {
        ipv4.addresses = [{
          address = "192.168.20.199";
          prefixLength = 24;
        }];
      };
      vlan99 = {
        ipv4.addresses = [{
          address = "192.168.99.199";
          prefixLength = 24;
        }];
      };
      vlan207 = {
        ipv4.addresses = [{
          address = "192.168.207.199";
          prefixLength = 24;
        }];
      };
    };
    vlans = {
      # Secure
      vlan20 = { id = 20; interface = "enp1s0"; };
      # Management
      vlan99 = { id = 99; interface = "enp1s0"; };
      # IOT
      vlan207 = { id = 207; interface = "enp1s0"; };
    };
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
  };
}