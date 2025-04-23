# Windows Subsystem for Linux

## Useful links

- https://nix-community.github.io/NixOS-WSL/install.html

## Install WSL

Follow installation instructions from [the installation guide](https://nix-community.github.io/NixOS-WSL/install.html). They basically say:

- Download `nixos.wsl`
- Run `wsl --install --from-file nixos.wsl` in PowerShell
- Make NixOS the default `wsl`-distribution with `wsl -s NixOS`

## Roll config

- Clone git repo
- Run same commands as in the main guide
