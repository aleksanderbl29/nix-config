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
    extraFlags = toString [
      "--write-kubeconfig-mode=644"
      "--node-label=homelab=true"
      "--node-label=role=server"
      "--node-label=name=ironhide"
      # Use Caddy on the host as the only ingress:
      # disable k3s' bundled Traefik and servicelb that otherwise bind 80/443.
      "--disable=traefik"
      "--disable=servicelb"
    ];
  };

  #### Tooling for interacting with the cluster ####

  environment.systemPackages = with pkgs; [
    kubectl
    fluxcd
  ];
}
