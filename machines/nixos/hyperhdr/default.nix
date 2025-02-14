{
  config,
  inputs,
  pkgs,
  name,
  ...
}: {
  imports = [
    ./hyperhdr.nix
    # ./sonos-stream.nix
  ];
}
