{
  description = "aleksanders systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11
    stable.url = "github:nixos/nixpkgs/nixos-24.05";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
  let
    system = "aarch64-darwin";
    user = "aleksanderbang-larsen";
  in {
    darwinConfigurations = {
      Aleksanders-MacBook-Pro = darwin.lib.darwinSystem {
          inherit system;
          pkgs = import nixpkgs { system = system; };
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # extraSpecialArgs = { inherit pkgs; };
                users.${user}.imports = [ ./modules/home-manager ];
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
                # extraSpecialArgs = { inherit pkgs; };
                users.${user}.imports = [ ./modules/home-manager ];
              };
            }
          ];
        };
    };
  };
}