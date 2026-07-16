{
  inputs,
  nixpkgs,
  ...
}:
let
  catppuccinConfig = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
  };

  nixosOverlays = [
    (
      final: prev:
      let
        karakeepPnpm10Patch = ''
          substituteInPlace pnpm-lock.yaml \
            --replace-fail 7nc6rwxl5vjub4hxnqupqavqpi cc2a1c1903e66d7f6cea77c615cb9ae3b36a694502c1c588c3e34d28aa925aac \
            --replace-fail kvggi4abfe6iel7wt6iiemonyq 725863c0591d89ca053226c49fe7bc321f320391ec5f78b6c2e8e41ab1868805
        '';
      in
      {
        fetchPnpmDeps =
          args:
          prev.fetchPnpmDeps (
            args
            //
              final.lib.optionalAttrs ((args.pname or null) == "jellarr" && (args.version or null) == "0.1.0")
                {
                  hash = "sha256-DA4PFpH+CZRHtreOlRHz0S3/93LdqlHVvsUyw9WAwII=";
                }
          );

        # Work around insecure pnpm pins until nixpkgs updates Karakeep.
        karakeep = (prev.karakeep.override { pnpm_9 = final.pnpm_10; }).overrideAttrs (old: {
          postPatch = old.postPatch + karakeepPnpm10Patch;
          pnpmDeps = final.fetchPnpmDeps {
            inherit (old)
              patches
              pname
              src
              version
              ;
            fetcherVersion = 3;
            hash = "sha256-fd9eMvTPHER1lp8tlXEMrnEf4cQsT/qtJbSwEiy64fY=";
            pnpm = final.pnpm_10;
            postPatch = karakeepPnpm10Patch;
          };
        });

        # The jellarr flake still uses fetchPnpmDeps fetcherVersion 3, which is
        # incompatible with the current pnpm_11 default.
        pnpm = prev.pnpm_10;
      }
    )
  ];
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
      };
      modules = [
        ../machines/darwin # shared darwin config
        ../machines/darwin/${hostname}.nix # machine-specific config

        inputs.nix-homebrew.darwinModules.nix-homebrew

        # Custom nvim config from nvf
        { environment.systemPackages = [ inputs.my-nvf.packages.${system}.default ]; }

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
        config.allowUnfree = true;
        overlays = nixosOverlays;
      };
      modules = [
        ../machines/nixos # shared nixos config
        ../machines/nixos/${hostname} # machine-specific config

        inputs.disko.nixosModules.disko

        # Custom nvim config from nvf
        { environment.systemPackages = [ inputs.my-nvf.packages.${system}.default ]; }

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
      };
      modules = [
        ../machines/darwin/work # shared darwin config for work
        ../machines/darwin/${hostname}.nix # machine-specific config

        inputs.nix-homebrew.darwinModules.nix-homebrew

        # Custom nvim config from nvf
        { environment.systemPackages = [ inputs.my-nvf.packages.${system}.default ]; }

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
