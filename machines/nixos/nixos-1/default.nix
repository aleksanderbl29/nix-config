{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
