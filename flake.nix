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

    # Configure nix-darwin machines
    mkDarwinConfig = { system, hostname }: darwin.lib.darwinSystem {
      inherit system;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      modules = [
        ./machines/darwin              # shared darwin config
        ./machines/darwin/${hostname}.nix  # machine-specific config

        home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit (nixpkgs.config) allowUnfree;
            };
            users.${mac_user} = { pkgs, ... }: {
              nixpkgs.config.allowUnfree = true;
              imports = [
                ./home              # shared home-manager config for all machines
                ./home/darwin.nix   # shared home-manager config for all darwin machines
              ];
            };
          };
        }
      ];
    };

    # Configure nixos machines
    mkNixosConfig = { system, hostname }: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./machines/nixos              # shared nixos config
        ./machines/nixos/${hostname}  # machine-specific config

        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} = { pkgs, ... }: {
              imports = [
                ./home    # same shared home-manager config
              ];
            };
          };
        }
      ];
    };
  in {
    darwinConfigurations = {
      aleks-old-mbp = mkDarwinConfig {
        system = m1;
        hostname = "aleks-old-mbp";
      };
      aleks-mbp = mkDarwinConfig {
        system = m1;
        hostname = "aleks-mbp";
      };
      Macbook-Air-tilhrende-Aleksander = mkDarwinConfig {
        system = "x86_64-darwin";
        hostname = "intel";
      };
    };

    nixosConfigurations = {
      n100 = mkNixosConfig {
        system = n100;
        hostname = "n100";
      };
      rpi = mkNixosConfig {
        system = rpi;
        hostname = "rpi";
      };
    };
  };
}