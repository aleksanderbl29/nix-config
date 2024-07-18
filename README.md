# nix-config

- Install Nix
```{bash}
curl -L https://nixos.org/nix/install | sh
```

- Install homebrew

```{bash}
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
```
