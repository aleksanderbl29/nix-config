{ ... }:
let
  user = "aleksander";
in
{
  nix = {
    settings = {
      trusted-users = [ user ];
    };
  };

  homebrew = {
    # masApps = {

    # };
    casks = [
      "home-assistant"
    ];
    brews = [
      "gcc"
      "btop"
      "cmatrix"
      "cowsay"
      "cryptography"
      "docker"
      "gh"
      "git"
      "graphviz"
      "helm"
      "imagemagick"
      "kompose"
      "kubernetes-cli"
      "mas"
      "minikube"
      "neofetch"
      "neovim"
      "netcat"
      "nmap"
      "openjdk"
      "pandoc"
      "starship"
      "tailscale"
      "tere"
      "tmux"
      "tree"
      "vim"
      "wimlib"
      "wireguard-tools"
      "hudochenkov/sshpass/sshpass"
      "teamookla/speedtest/speedtest"
    ];
  };

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };
}