{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    colmena
    sops
    age
  ];

  shellHook = ''
    export SOPS_AGE_KEY_FILE="''${HOME}/.config/sops/age/keys.txt"
  '';
}
