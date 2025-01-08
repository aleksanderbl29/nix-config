{
  description = "aleksander's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-24.05";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, nix-homebrew, homebrew-cask, homebrew-core, ... }:
  let
    m1 = "aarch64-darwin";
    rpi = "aarch64-linux";
    n100 = "x86_64-linux";
    mac_user = "aleksanderbang-larsen";
    user = "aleksander";
  in {
    darwinConfigurations = {
      Aleksanders-MacBook-Pro = darwin.lib.darwinSystem {
          system = m1;
          pkgs = import nixpkgs { system = m1; };
          modules = [
            ./modules/darwin
            # ./modules/homebrew
            home-manager.darwinModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${mac_useruser}.imports = [ ./modules/home-manager ];
              };
            }
          ];
        };
      Macbook-Air-tilhrende-Aleksander = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          pkgs = import nixpkgs { system = "x86_64-darwin"; };
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${mac_user}.imports = [ ./modules/home-manager ];
              };
            }
          ];
        };
    };
  };
}