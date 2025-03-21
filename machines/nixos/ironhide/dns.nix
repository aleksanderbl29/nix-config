{ config, lib, pkgs, ... }:

let
  # Define your network details
  networks = {
    vlan20 = {
      interface = "vlan20";
      ip = "192.168.20.199";
      subnet = "192.168.20.0/24";
      description = "Secure Network";
    };
    vlan99 = {
      interface = "vlan99";
      ip = "192.168.99.199";
      subnet = "192.168.99.0/24";
      description = "Management Network";
    };
    vlan207 = {
      interface = "vlan207";
      ip = "192.168.207.199";
      subnet = "192.168.207.0/24";
      description = "IOT Network";
    };
  };

  # Define your domain names and services
  customDns = {
    jellyfin = {
      name = "jellyfin.local.aleksanderbl.dk";
      proxypass = "http://localhost:8096";
      allowedNetworks = [ "vlan20" "vlan99" ]; # Only accessible from secure and management networks
    };
    nextcloud = {
      name = "nextcloud.local.aleksanderbl.dk";
      proxypass = "http://localhost:8080";
      allowedNetworks = [ "vlan20" "vlan99" ]; # Only accessible from secure and management networks
    };
    homeassistant = {
      name = "ha.local.aleksanderbl.dk";
      proxypass = "http://localhost:8123";
      allowedNetworks = [ "vlan20" "vlan99" "vlan207" ]; # Accessible from all networks
    };
  };

  # Build the Docker image using dockerTools
  dnsImage = pkgs.dockerTools.buildImage {
    name = "local/dns";
    tag = "latest";
    created = "now";
    fromImage = pkgs.dockerTools.pullImage {
      imageName = "alpine";
      imageDigest = "sha256:c5c5fda71656f28e49ac9c5416b3643eaa6a108a809d1f3d3d0b0e02d7495d539";
    };
    contents = [ pkgs.bash ];
    config = {
      Cmd = [ "/init-unbound.sh" ];
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
      cp ${./dns/unbound.conf} $out/etc/unbound/unbound.conf
      cp ${./dns/local.conf} $out/etc/unbound/conf.d/local.conf
      cp ${./dns/init-unbound.sh} $out/init-unbound.sh

      # Make init script executable
      chmod +x $out/init-unbound.sh

      # Install packages using apk
      apk add --no-cache unbound unbound-anchor ca-certificates tzdata
    '';
  };
in
{
  # Build and load the Docker image
  system.activationScripts.dns-setup = ''
    docker load < ${dnsImage}
  '';

  virtualisation.oci-containers = {
    containers = {
      dns = {
        image = "local/dns:latest";
        ports = [ "53:53/udp" "53:53/tcp" ];
        environment = {
          TZ = "Europe/Copenhagen";
        };
        extraOptions = [
          "--network=host"
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--restart=unless-stopped"
        ];
        autoStart = true;
        dependsOn = [ "dns-setup" ];
      };
    };
  };
}
