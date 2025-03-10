{
  config,
  ...
}:
{
  services.k3s = {
    enable = false;
    role = "server";
    tokenFile = /var/lib/rancher/k3s/server/token;
    # token = "INSERT RANDOM TOKEN HERE WHEN INITIALISING";
    extraFlags = toString ([
      "--write-kubeconfig-mode \"0644\""
      "--cluster-init"
      "--disable servicelb"
      "--disable traefik"
      "--disable local-storage"
    ] ++ (if config.networking.hostName == "k3s-1" then [] else [
        "--server https://k3s-1:6443"
    ]));
    clusterInit = (config.networking.hostName == "k3s-1");
  };
}
