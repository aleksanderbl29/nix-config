{ ... }:

{
  networking = {
    hostName = "soundwave";
    hostId = "007f0200";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
  };
}
