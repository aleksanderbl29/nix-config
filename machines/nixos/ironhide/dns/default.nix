{ pkgs, networks, customDns }:

let
  # Create unbound.conf from template
  unboundConf = pkgs.writeText "unbound.conf" ''
    server:
        # General settings
        verbosity: 1
        interface: 0.0.0.0
        port: 53
        do-ip4: yes
        do-ip6: yes
        do-udp: yes
        do-tcp: yes
        access-control: 127.0.0.1/32 allow
        access-control: ${networks.vlan20.subnet} allow
        access-control: ${networks.vlan99.subnet} allow
        access-control: ${networks.vlan207.subnet} allow

        # Security settings
        hide-identity: yes
        hide-version: yes
        harden-glue: yes
        harden-dnssec-stripped: yes
        use-caps-for-id: yes
        edns-buffer-size: 1232
        prefetch: yes
        prefetch-key: yes
        qname-minimisation: yes
        rrset-roundrobin: yes
        minimal-responses: yes

        # DNSSEC
        auto-trust-anchor-file: "/etc/unbound/anchors/root.key"
        root-hints: "/etc/unbound/root.hints"

        # Cache settings
        cache-min-ttl: 300
        cache-max-ttl: 86400
        cache-max-negative-ttl: 3600

        # Forward queries to Cloudflare
        forward-zone:
            name: "."
            forward-addr: 1.1.1.1
            forward-addr: 1.0.0.1
            forward-tls-upstream: yes
  '';

  # Create local.conf from template
  localConf = pkgs.writeText "local.conf" ''
    server:
        # Local zone configuration
        local-zone: "local.aleksanderbl.dk" static
        ${builtins.concatStringsSep "\n" (map (service:
          ''local-data: "${service.name}. IN A ${networks.vlan20.ip}"''
        ) (builtins.attrValues customDns))}
        local-data: "*.local.aleksanderbl.dk. IN A ${networks.vlan20.ip}"
  '';

  # Create a script to initialize unbound
  initScript = pkgs.writeScript "init-unbound.sh" ''
    #!/bin/sh
    set -e

    # Create necessary directories
    mkdir -p /etc/unbound/anchors

    # Generate root hints if they don't exist
    if [ ! -f /etc/unbound/anchors/root.key ]; then
      unbound-anchor -a /etc/unbound/anchors/root.key || true
    fi

    # Start unbound
    exec unbound -d
  '';

  # Create the Docker image
  dnsImage = pkgs.dockerTools.buildImage {
    name = "local/dns";
    tag = "latest";
    created = "now";
    contents = [
      pkgs.unbound
      pkgs.unbound-anchor
      pkgs.ca-certificates
      pkgs.tzdata
      pkgs.bash
    ];
    config = {
      Cmd = [ "/bin/sh" "${initScript}" ];
      ExposedPorts = {
        "53/udp" = {};
        "53/tcp" = {};
      };
      Env = [
        "TZ=Europe/Copenhagen"
        "PATH=/bin:/usr/bin:/sbin:/usr/sbin"
      ];
    };
    extraCommands = ''
      # Create necessary directories
      mkdir -p $out/etc/unbound/conf.d
      mkdir -p $out/etc/unbound/anchors

      # Copy configuration files
      cp ${unboundConf} $out/etc/unbound/unbound.conf
      cp ${localConf} $out/etc/unbound/conf.d/local.conf

      # Make init script executable
      chmod +x ${initScript}
    '';
  };
in
dnsImage
