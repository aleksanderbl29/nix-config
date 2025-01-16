{ ... }:
let
  user = "aleksanderbang-larsen";
in
{
  imports = [
    ./homebrew.nix
  ];

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };

  # nix-homebrew = {
  #   enable = true;
  #   enableRosetta = true;
  #   user = "${ user }";
  #   mutableTaps = false;
  #   taps = {
  #     "homebrew/homebrew-core" = homebrew-core;
  #     "homebrew/homebrew-cask" = homebrew-cask;
  #     "homebrew/homebrew-bundle" = homebrew-bundle;
  #   };
  #   autoMigrate = true;
  # };
}