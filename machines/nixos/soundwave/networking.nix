{ ... }:

{
  networking = {
    hostName = "soundwave";
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "9.9.9.9"
    ];
  };
}
