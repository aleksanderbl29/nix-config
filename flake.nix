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

    mkDarwinConfig = system: darwin.lib.darwinSystem {
      inherit system;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit (nixpkgs.config) allowUnfree;
            };
            users.${mac_user} = { pkgs, ... }: {
              nixpkgs.config.allowUnfree = true;  # Add this line
              imports = [ ./modules/home-manager ];
            };
          };
        }
      ];
    };
  in {
    darwinConfigurations = {
      Aleksanders-MacBook-Pro = mkDarwinConfig m1;
      Macbook-Air-tilhrende-Aleksander = mkDarwinConfig "x86_64-darwin";
    };
  };
}