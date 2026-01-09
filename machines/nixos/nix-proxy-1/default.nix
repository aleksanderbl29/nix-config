{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ./proxy.nix
    ./status.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "nix-proxy-1";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpoAMN4OFauCaNhOID7WbTLlo5F72qcKONB8y8T3IQrXxynwafZmXWdAsyw3TFci6P0WYyEQQQoSnWo7NaUxdSPz0GHa1RHzgfhq00N+xCgMIBIRe3WFK2nnlf5GA3QZ0Pq6EaLjTj36XoGCVPBA+HHn8xqmnIbq/yb1neLrNT0dtsR7DDxchFr574g7SyEMnpNmLJBrK6Uw4iFLKkpFYuAs0i/cWU6DhjRJh4dxkHhYXylvMAcdmEl8rSbPBad9hWUtvhrNjVxu8KLIzcvr8FVbocx2C/8wnZUOEqCWQYK+IYckq+Yi60a72wCFd852QLCC45yLKZ/fNf0HsuWl66zd/we90afqACISZ1cckTyxAq+QU3wah6ypBvpae9SfVnxRC3cpB6tXX+2vkrAMIUA4CWqBtGS96bFc21GLT5wbh/RdZBaiqzP1scIIgf09TFgO/qBlZUZrdkwqK1nKLydUWXpg+jBVdgS5ehITbIDJKWilQmXITQ3O+HFmWckm8=''
  ];
  system.stateVersion = "24.11";

  proxy.enable = true;
  homelab = {
    enable = true;
    services = {
      gatus.enable = true;
    };
    publicExpose = {
      bookmarks = true;
      jellyfin = true;
      status = true;
      git = true;
      ha = true;
    };
  };
}
