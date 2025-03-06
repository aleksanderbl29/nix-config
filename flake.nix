{
  description = "aleksander's systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-24.11";

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
    homebrew-services = {
      url = "github:Homebrew/homebrew-services";
      flake = false;
    };
    homebrew-sshpass = {
      url = "github:hudochenkov/homebrew-sshpass";
      flake = false;
    };
    homebrew-speedtest = {
      url = "github:teamookla/homebrew-speedtest";
      flake = false;
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    my-nvf = {
      url = "github:aleksanderbl29/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      darwin,
      home-manager,
      nix-homebrew,
      nix-vscode-extensions,
      my-nvf,
      ...
    }:
    with inputs;
    let
      inherit (self) outputs;
      libs = import ./lib {
        inherit
          inputs
          outputs
          myOverlays
          nixpkgs
          ;
      };
      myOverlays = [ inputs.nix-vscode-extensions.overlays.default ];
    in
    {
      darwinConfigurations = {
        aleks-old-mbp = libs.mkDarwinConfig {
          hostname = "aleks-old-mbp";
        };
        aleks-mbp = libs.mkDarwinConfig {
          hostname = "aleks-mbp";
        };
        aleks-air = libs.mkDarwinConfig {
          hostname = "aleks-air";
          system = "x86_64-darwin";
        };
      };

      nixosConfigurations = {
        # Oracle Cloud
        oci-nix-1 = libs.mkNixosConfig {
          hostname = "oci-nix-1";
        };

        k3s-1 = libs.mkNixosConfig {
          hostname = "k3s-1";
        };

        k3s-2 = libs.mkNixosConfig {
          hostname = "k3s-2";
        };

        k3s-3 = libs.mkNixosConfig {
          hostname = "k3s-3";
        };

        # Commented out configurations
        #   # n100 = libs.mkNixosConfig {
        #   #   system = n100;
        #   #   hostname = "n100";
        #   # };
        #   hyperhdr = libs.mkNixosConfig {
        #     system = rpi;
        #     hostname = "hyperhdr";
        #   };
      };
    };
}
