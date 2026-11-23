#!/usr/bin/env bash
set -euo pipefail

# Run from the repository root with nix develop -c bash homelab/tests/finance-proxy.sh.
test_dir=$(mktemp -d)
trap 'if [[ -n "${caddy_pid:-}" ]]; then kill "$caddy_pid"; wait "$caddy_pid" || true; fi; rm -rf "$test_dir"' EXIT

printf '{\n admin off\n auto_https off\n}\n' >"$test_dir/Caddyfile"
for service in actual wealthfolio; do
  nix eval --raw ".#nixosConfigurations.ironhide.config.services.caddy.virtualHosts.\"$service.local.aleksanderbl.dk\".extraConfig" >"$test_dir/$service"
done

for entry in actual:19401:19506 wealthfolio:19402:19588; do
  IFS=: read -r service port backend <<<"$entry"
  for mode in denied allowed; do
    printf 'http://127.0.0.1:%s {\n' "$port" >>"$test_dir/Caddyfile"
    # Keep the evaluated routes and use a local mock upstream. For the positive
    # case only, simulate a tailnet peer with the loopback source range.
    sed -e '/^[[:space:]]*tls /d' \
      -e "s/reverse_proxy 127.0.0.1:[0-9]*/reverse_proxy 127.0.0.1:$backend/" \
      "$test_dir/$service" >"$test_dir/route"
    if [[ "$mode" == allowed ]]; then
      sed -i 's@100.64.0.0/10@127.0.0.0/8@' "$test_dir/route"
    fi
    cat "$test_dir/route" >>"$test_dir/Caddyfile"
    printf '}\n' >>"$test_dir/Caddyfile"
    port=$((port + 2))
  done
  printf 'http://127.0.0.1:%s {\n respond "upstream reached" 200\n}\n' "$backend" >>"$test_dir/Caddyfile"
done

caddy adapt --config "$test_dir/Caddyfile" --adapter caddyfile >/dev/null
caddy run --config "$test_dir/Caddyfile" --adapter caddyfile >"$test_dir/log" 2>&1 &
caddy_pid=$!
for attempt in {1..50}; do
  if curl --silent --output /dev/null http://127.0.0.1:19401; then break; fi
  sleep 0.1
done

for port in 19401 19402; do
  test "$(curl --silent --output /dev/null --write-out '%{http_code}' "http://127.0.0.1:$port")" = 403
  test "$(curl --silent --output /dev/null --write-out '%{http_code}' \
    -H 'X-Forwarded-For: 100.64.0.1' -H 'X-Real-IP: 100.64.0.1' \
    -H 'Forwarded: for=100.64.0.1' "http://127.0.0.1:$port")" = 403
done
for port in 19403 19404; do
  test "$(curl --silent --fail "http://127.0.0.1:$port")" = 'upstream reached'
done
curl --silent --fail --dump-header "$test_dir/headers" --output /dev/null http://127.0.0.1:19403
grep -qi '^Cross-Origin-Opener-Policy: same-origin' "$test_dir/headers"
grep -qi '^Cross-Origin-Embedder-Policy: require-corp' "$test_dir/headers"
printf 'PASS: both routes deny non-tailnet and spoofed peers; simulated allowed peers reach upstream; Actual isolation headers are present.\n'
