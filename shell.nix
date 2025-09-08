{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    colmena
    sops
    age
    nix-output-monitor
  ];

  shellHook = ''
    export SOPS_AGE_KEY_FILE="''${HOME}/.config/sops/age/keys.txt"
  '';
}
