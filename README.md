# nix-config

## Installation Steps

### 1. Install Nix using Determinate Systems installer

```zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

### 2. Clone this repo

- Use git in a temporary nix-shell

```zsh
nix-shell -p git
```

Clone the repo

```zsh
mkdir ~/nix-config
cd ~/nix-config
git clone https://github.com/aleksanderbl29/nix-config .
```

### 3. Build the system for the first time

MacOS

```zsh
nix run nix-darwin -- switch --flake ~/nix-config/
```

NixOS

```zsh
sudo nixos-rebuild switch --flake ~/nix-config#
```

All subsequent rebuilds can be done with the same command on all systems

```zsh
nixswitch
```
