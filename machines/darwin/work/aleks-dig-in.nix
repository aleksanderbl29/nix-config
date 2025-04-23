{
  pkgs,
  ...
}:
{
  imports = [
  ];

  nix = {
    settings = {
      trusted-users = [ "aleksander" ];
    };
  };

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
    systemPackages = with pkgs; [
    ];
  };
}
