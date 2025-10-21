{
  description = "aleksander's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ai-tools.url = "github:numtide/nix-ai-tools";

    catppuccin = {
      url = "github:catppuccin/nix";
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
    homebrew-services = {
      url = "github:Homebrew/homebrew-services";
      flake = false;
    };
    # personal-homebrew = {
    #   url = "github:aleksanderbl29/homebrew-cask/add-zoho-cliq";
    #   flake = false;
    # };

    my-nvf = {
      url = "github:aleksanderbl29/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    with inputs;
    let
      inherit (self) outputs;
      libs = import ./lib {
        inherit
          inputs
          outputs
          nixpkgs
          ;
      };
    in
    {
      darwinConfigurations = {
        aleks-mbp = libs.mkDarwinConfig { hostname = "aleks-mbp"; };
        aleks-air = libs.mkDarwinConfig {
          hostname = "aleks-air";
          system = "x86_64-darwin";
        };
        aleks-dig-in = libs.mkWorkconfig { hostname = "aleks-dig-in"; };
      };

      nixosConfigurations = {
        ironhide = libs.mkNixosConfig { hostname = "ironhide"; };
        nix-proxy-1 = libs.mkNixosConfig { hostname = "nix-proxy-1"; };
      };

      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          specialArgs = { inherit inputs; };
        };
        defaults =
          { ... }:
          {
            imports = [
              inputs.home-manager.nixosModules.home-manager
              ./machines/colmena
            ];
          };

        ironhide = import ./machines/colmena/ironhide;
        nix-proxy-1 = import ./machines/colmena/nix-proxy-1;
      };
    };
}
