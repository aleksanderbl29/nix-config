{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log = {
        level = "WARN";
      };
      api = {}; # enable API handler
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
        };
      };
      certificatesResolvers = {
        cloudflare = {
          acme = {
            email = "aleksanderbl@live.dk";
            storage = "/var/lib/traefik/acme.json";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
            };
          };
        };
      };
    };
    dynamicConfigOptions = {
      http = {
        middlewares = {
          auth = {
            basicAuth = {
              users = ["sysadmin:$apr1$hmCNzdDy$ktQcLQuxx4Jj99hAK5JIL0"];
            };
          };
        };
        routers = {
          api = {
            rule = "Host(`traefik-dashboard.local.aleksanderbl.dk`)";
            service = "api@internal";
            entrypoints = ["websecure"];
            middlewares = ["auth"];
            tls = {
              certResolver = "cloudflare";
            };
          };
        };
      };
    };
  };

  system.activationScripts.traefikEnv = {
    text = ''
      echo "Creating Traefik env file..."
      cat > /var/lib/traefik/env << 'EOF'
      CF_API_EMAIL=aleksanderbl@live.dk
      CF_API_KEY=19cd68001a818139eee940a6f3005d324bfef
      BASIC_AUTH=sysadmin:$$apr1$$hmCNzdDy$$ktQcLQuxx4Jj99hAK5JIL0
      EOF
      chmod 600 /var/lib/traefik/env
    '';
    deps = [];
  };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = ["/var/lib/traefik/env"];
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
