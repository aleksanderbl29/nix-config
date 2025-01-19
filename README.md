# nix-config

[![Nix Config Validation](https://github.com/aleksanderbl29/nix-config/actions/workflows/ci.yml/badge.svg)](https://github.com/aleksanderbl29/nix-config/actions/workflows/ci.yml)

## Installation Steps

### 1. Install Nix using Determinate Systems installer

```zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

### 2. Install Xcode Command Line Tools (if on mac)

```zsh
xcode-select --install
```

### 3. Clone this repo

- Use git in a temporary nix-shell

```zsh
nix-shell -p git
```

Clone the repo.

```zsh
mkdir ~/nix-config
cd ~/nix-config
git clone https://github.com/aleksanderbl29/nix-config .
```

Exit the nix-shell after cloning the repo.

### 4. Build the system for the first time

You don't have to specify the hostname as long as the machine hostname is one of the outputs in `flake.nix`.

MacOS

```zsh
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/nix-config/
```

NixOS

```zsh
sudo nixos-rebuild switch --flake ~/nix-config#
```

All subsequent rebuilds can be done with the same command on all systems.

```zsh
nixswitch
```
