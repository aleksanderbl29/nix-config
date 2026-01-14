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

    # Initialize the cluster on this first server node using embedded etcd.
    clusterInit = true;

    # Extra flags for k3s server:
    # - write kubeconfig readable by root/wheel
    # - label the node so it is easy to target in workloads
    extraFlags = lib.concatStringsSep " " [
      "--write-kubeconfig-mode=644"
      "--node-label=homelab=true"
      "--node-label=role=server"
    ];

    # NOTE: k3s will generate a token for joining agents/servers.
    # For future nodes, you can copy the token from
    #   /var/lib/rancher/k3s/server/node-token
    # on this node or manage it via your preferred secret mechanism.
  };

  #### Tooling for interacting with the cluster and Flux ####

  environment.systemPackages = with pkgs; [
    kubectl
    fluxcd
  ];

  #### Flux bootstrap manifests: mounted into /etc/flux/bootstrap ####

  environment.etc = {
    "flux/bootstrap/cluster-gitrepo.yaml".text = ''
      apiVersion: source.toolkit.fluxcd.io/v1
      kind: GitRepository
      metadata:
        name: flux-system
        namespace: flux-system
      spec:
        interval: 1m0s
        url: https://github.com/aleksanderbl29/homeops.git
        ref:
          branch: main
    '';

    "flux/bootstrap/cluster-kustomization.yaml".text = ''
      apiVersion: kustomize.toolkit.fluxcd.io/v1
      kind: Kustomization
      metadata:
        name: flux-system
        namespace: flux-system
      spec:
        interval: 1m0s
        path: ./clusters/ironhide
        prune: true
        sourceRef:
          kind: GitRepository
          name: flux-system
        wait: true
    '';
  };

  #### One-shot Flux bootstrap service ####

  systemd.services.flux-bootstrap = {
    description = "Bootstrap FluxCD into the k3s cluster on ironhide";

    # Ensure networking and k3s are ready first
    after = [
      "network-online.target"
      "k3s.service"
    ];
    wants = [
      "network-online.target"
      "k3s.service"
    ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";

      # Only run once: skip if the marker file exists
      ExecCondition = "${pkgs.bash}/bin/bash -c '[ ! -f /var/lib/flux/bootstrap.done ]'";

      # Use the k3s-generated kubeconfig
      Environment = [
        "KUBECONFIG=/etc/rancher/k3s/k3s.yaml"
      ];

      # Install Flux CRDs/controllers and apply initial GitRepository/Kustomization
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.fluxcd}/bin/flux install --namespace=flux-system && ${pkgs.kubectl}/bin/kubectl apply -f /etc/flux/bootstrap'";

      # Mark bootstrap as completed
      ExecStartPost = "${pkgs.bash}/bin/bash -c 'mkdir -p /var/lib/flux && touch /var/lib/flux/bootstrap.done'";
    };
  };
}
