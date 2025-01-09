# nix-config

- Install Nix

```{bash}
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

- Install homebrew
  - Don't do this if the machine should use nix-homebrew

```{bash}
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Install Rosetta (if on M-series mac)
  - Maybe do this?

```{bash}
softwareupdate --install-rosetta --agree-to-license
```

- Install git

```{bash}
brew intall git
```

- Clone this repo

```{bash}
mkdir ~/src/
cd ~/src/
git clone https://github.com/aleksanderbl29/nix-config nix-mbp
```

- Enable experimental nix features

```{bash}
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF
```

- Nix run

```{bash}
nix run nix-darwin -- switch --flake ~/src/nix-mbp/
```

- Rebuild

```{bash}
darwin-rebuild switch --flake ~/src/nix-mbp/
# Also alias nixswitch
```
