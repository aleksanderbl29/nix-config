{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  #### k3s server configuration for ironhide ####

  services.k3s = {
    enable = true;
    role = "server";

    # Reference the token file path.
    # If the file exists, it will be used; otherwise k3s will generate a new token.
    tokenFile = "/var/lib/rancher/k3s/server/node-token";

    # Initialize the cluster on this first server node using embedded etcd.
    # If tokenFile exists and contains a valid token, this will reuse the existing cluster.
    # If tokenFile doesn't exist, k3s will generate a new token and initialize a new cluster.
    clusterInit = true;

    # Extra flags for k3s server:
    # - write kubeconfig readable by root/wheel
    # - label the node so it is easy to target in workloads
    # - bind to vlan99 (Management VLAN) so Traefik/servicelb use that interface
    #   This allows Caddy to use 80/443 on the main interface while k3s uses vlan99
    extraFlags = toString [
      "--write-kubeconfig-mode=644"
      "--node-label=homelab=true"
      "--node-label=role=server"
      "--node-label=name=ironhide"
      # Bind k3s API server and services to vlan99 (Management VLAN) at 192.168.99.222
      # This allows Traefik and servicelb to use 80/443 on vlan99
      # while Caddy uses 80/443 on the main interface (enp1s0)
      "--node-ip=192.168.99.222"
      "--bind-address=192.168.99.222"
      "--advertise-address=192.168.99.222"
    ];
  };

  #### Tooling for interacting with the cluster ####

  environment.systemPackages = with pkgs; [
    kubectl
    fluxcd
  ];

}
