{
  inputs,
  myOverlays,
  nixpkgs,
  ...
}:
let
  catppuccinConfig = {
    enable = true;
    flavor = "mocha";
  };
in
{

  # Configure nix-darwin machines
  mkDarwinConfig =
    {
      hostname,
      user ? "aleksander",
      system ? "aarch64-darwin",
    }:
    inputs.darwin.lib.darwinSystem {
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
        ../machines/darwin # shared darwin config
        ../machines/darwin/${hostname}.nix # machine-specific config

        inputs.nix-homebrew.darwinModules.nix-homebrew

        # Custom nvim config from nvf
        { environment.systemPackages = [ inputs.my-nvf.packages.${system}.default ]; }

        { environment.systemPackages = [ "nix-output-monitor" ]; }

        # Colmena dev version
        # { environment.systemPackages = [ inputs.colmena.packages.${system}.colmena ]; }

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit (nixpkgs.config) allowUnfree; };
            users.${user} =
              { ... }:
              {
                imports = [
                  ../home # shared home-manager config for all machines
                  ../home/darwin.nix # shared home-manager config for all darwin machines
                  ../home/${hostname}.nix # machine-specific home-manager config
                  inputs.catppuccin.homeModules.catppuccin
                ];
                catppuccin = catppuccinConfig;
              };
          };
        }
      ];
    };

  # Configure nixos machines
  mkNixosConfig =
    {
      hostname,
      user ? "aleksander",
      system ? "x86_64-linux",
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
        ../machines/nixos # shared nixos config
        ../machines/nixos/${hostname} # machine-specific config

        # Custom nvim config from nvf
        { environment.systemPackages = [ inputs.my-nvf.packages.${system}.default ]; }

        { environment.systemPackages = [ "nix-output-monitor"]; }

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} =
              { ... }:
              {
                imports = [
                  ../home # same shared home-manager config
                  inputs.catppuccin.homeModules.catppuccin
                ];
                catppuccin = catppuccinConfig;
              };
          };
        }
      ];
    };

  mkWorkconfig =
    {
      hostname,
      user ? "aleksander",
      system ? "aarch64-darwin",
    }:
    inputs.darwin.lib.darwinSystem {
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
        ../machines/darwin/work # shared darwin config for work
        ../machines/darwin/${hostname}.nix # machine-specific config

        inputs.nix-homebrew.darwinModules.nix-homebrew

        # Custom nvim config from nvf
        { environment.systemPackages = [ inputs.my-nvf.packages.${system}.default ]; }

        { environment.systemPackages = [ "nix-output-monitor"]; }

        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit (nixpkgs.config) allowUnfree; };
            users.${user} =
              { ... }:
              {
                imports = [
                  ../home/work.nix # shared home-manager config for all darwin machines
                  inputs.catppuccin.homeModules.catppuccin
                ];
                catppuccin = catppuccinConfig;
              };
          };
        }
      ];
    };
}
