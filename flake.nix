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
    let
      m1 = "aarch64-darwin";
      user = "aleksander";

      myOverlays = [ inputs.nix-vscode-extensions.overlays.default ];

      # Configure nix-darwin machines
      mkDarwinConfig =
        {
          system,
          hostname,
        }:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
            overlays = myOverlays;
          };
          modules = [
            ./machines/darwin # shared darwin config
            ./machines/darwin/${hostname}.nix # machine-specific config

            inputs.nix-homebrew.darwinModules.nix-homebrew

            # Custom nvim config from nvf
            { environment.systemPackages = [ my-nvf.packages.${system}.default ]; }

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit (nixpkgs.config) allowUnfree; };
                users.${user} =
                  { ... }:
                  {
                    imports = [
                      ./home # shared home-manager config for all machines
                      ./home/darwin.nix # shared home-manager config for all darwin machines
                      ./home/${hostname}.nix # machine-specific home-manager config
                    ];
                  };
              };
            }
          ];
        };

      # Configure nixos machines
      mkNixosConfig =
        {
          system,
          hostname,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
            overlays = myOverlays;
          };
          modules = [
            ./machines/nixos # shared nixos config
            ./machines/nixos/${hostname} # machine-specific config

            # Custom nvim config from nvf
            { environment.systemPackages = [ my-nvf.packages.${system}.default ]; }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} =
                  { ... }:
                  {
                    imports = [
                      ./home # same shared home-manager config
                    ];
                  };
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        aleks-old-mbp = mkDarwinConfig {
          system = m1;
          hostname = "aleks-old-mbp";
        };
        aleks-mbp = mkDarwinConfig {
          system = m1;
          hostname = "aleks-mbp";
        };
        aleks-air = mkDarwinConfig {
          system = "x86_64-darwin";
          hostname = "aleks-air";
        };
      };

      nixosConfigurations = {
        nixos-1 = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "nixos-1";
        };

        # Oracle Cloud
        oci-nix-1 = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "oci-nix-1";
        };

        k3s-1 = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "k3s-1";
        };

        k3s-2 = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "k3s-2";
        };

        k3s-3 = mkNixosConfig {
          system = "x86_64-linux";
          hostname = "k3s-3";
        };

        # Commented out configurations
        #   # n100 = mkNixosConfig {
        #   #   system = n100;
        #   #   hostname = "n100";
        #   # };
        #   hyperhdr = mkNixosConfig {
        #     system = rpi;
        #     hostname = "hyperhdr";
        #   };
      };
    };
}
