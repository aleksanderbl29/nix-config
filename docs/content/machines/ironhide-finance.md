# Set up the finance services on Ironhide

Ironhide enables Actual Budget and Wealthfolio through native NixOS modules.
After deployment, open these URLs from a tailnet device:

- Actual Budget: https://actual.local.aleksanderbl.dk
- Wealthfolio: https://wealthfolio.local.aleksanderbl.dk

Configure both DNS names to resolve to Ironhide's Tailscale address. A connection
through Ironhide's LAN address is rejected with HTTP 403. Caddy checks the direct
peer against Tailscale's IPv4 and IPv6 ranges and ignores forwarded client
addresses for this decision. Tailnet ACLs still determine which peers can connect.
Neither service is added to the public proxy.

HTTPS uses the existing homelab wildcard certificate and Cloudflare ACME setup.
The application backends listen on localhost, with no application firewall ports
opened. Actual uses port 5006; Wealthfolio uses port 8088.

## Provision Wealthfolio credentials

Before deploying, run these commands from a checkout on Ironhide. The development
shell supplies OpenSSL and Argon2:

```sh
nix develop -c bash
set -euo pipefail
sudo install -d -m 0700 -o root -g root /var/lib/wealthfolio-secrets
if ! sudo test -e /var/lib/wealthfolio-secrets/key; then
  openssl rand -base64 32 | sudo tee /var/lib/wealthfolio-secrets/key >/dev/null
fi
read -rsp 'Wealthfolio login password: ' wealthfolio_password
printf '\n'
printf '%s' "$wealthfolio_password" |
  argon2 "$(openssl rand -hex 16)" -id -e |
  sudo tee /var/lib/wealthfolio-secrets/password-hash >/dev/null
unset wealthfolio_password
sudo chmod 0600 /var/lib/wealthfolio-secrets/key /var/lib/wealthfolio-secrets/password-hash
exit
```

Keep the existing key on subsequent deployments. Back it up securely; Wealthfolio
uses it to encrypt stored secrets. The password hash defines the web login.
Both files stay outside the Nix store and are passed through systemd credentials.
Wealthfolio fails to start if either file is missing.

Actual prompts you to set its server password on the first visit.

## Back up application data

Back up `/var/lib/actual`, `/var/lib/wealthfolio`, and
`/var/lib/wealthfolio-secrets`. The native modules manage the application
directories with systemd dynamic users; follow directory symlinks when taking a
backup. Stop `actual.service` and `wealthfolio.service` while making a file-level
backup so the SQLite databases and their WAL files remain consistent.

## Check the configuration

Run these commands from the repository root:

```sh
nix develop -c nix eval --impure --json --file homelab/tests/finance.nix
nix develop -c bash homelab/tests/finance-proxy.sh
nix develop -c nix eval --raw .#nixosConfigurations.ironhide.config.system.build.toplevel.drvPath
nix develop -c nix flake check --no-build
nix develop -c nixfmt --check flake.nix homelab/services/actual/default.nix homelab/services/wealthfolio/default.nix homelab/services/default.nix machines/nixos/ironhide/homelab.nix homelab/tests/finance.nix
nix develop -c deadnix --fail homelab/services/actual homelab/services/wealthfolio homelab/tests/finance.nix
```

After deployment, verify that both URLs load over the tailnet and return HTTP 403
when accessed through a LAN address, including with a forged
`X-Forwarded-For: 100.64.0.1` header. Confirm that ports 5006 and 8088 cannot be
reached from another machine.

The upstream references describe
[Actual's HTTPS requirements](https://actualbudget.org/docs/config/reverse-proxies/)
and [Wealthfolio credentials](https://wealthfolio.app/docs/guide/self-hosting/configuration/).
