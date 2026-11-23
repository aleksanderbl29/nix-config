let
  flake = builtins.getFlake (toString ../..);
  config = flake.nixosConfigurations.ironhide.config;
  lib = flake.inputs.nixpkgs.lib;
  actual = config.services.actual;
  wealthfolio = config.services.wealthfolio;
  services = config.homelab.services;
  privateRoute =
    name:
    let
      route = config.services.caddy.virtualHosts.${services.${name}.url}.extraConfig;
    in
    lib.hasInfix "@tailnet remote_ip 100.64.0.0/10 fd7a:115c:a1e0::/48" route
    && lib.hasInfix "respond \"Tailnet access only\" 403" route
    && (config.homelab.publicExpose.${name} or false) == false;
in
assert actual.enable && actual.settings.hostname == "127.0.0.1" && !actual.openFirewall;
assert wealthfolio.enable && wealthfolio.address == "127.0.0.1" && !wealthfolio.openFirewall;
assert actual.settings.port != wealthfolio.port;
assert !(builtins.elem actual.settings.port config.networking.firewall.allowedTCPPorts);
assert !(builtins.elem wealthfolio.port config.networking.firewall.allowedTCPPorts);
assert wealthfolio.authRequired && wealthfolio.cookieSecure == "true";
assert wealthfolio.corsAllowOrigins == "https://${services.wealthfolio.url}";
assert
  config.systemd.services.wealthfolio.serviceConfig.LoadCredential == [
    "secret_key:/var/lib/wealthfolio-secrets/key"
    "auth_hash:/var/lib/wealthfolio-secrets/password-hash"
  ];
assert privateRoute "actual" && privateRoute "wealthfolio";
{
  actual = services.actual.url;
  wealthfolio = services.wealthfolio.url;
  result = "Both native services use loopback backends and tailnet-only HTTPS routes.";
}
