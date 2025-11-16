{
  lib,
  ...
}:
{
  imports = [
    ../../nixos/hyperhdr
  ];

  deployment = {
    buildOnTarget = lib.mkForce false;
  };

}
