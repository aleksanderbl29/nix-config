{
  pkgs,
  ...
}:
{
  imports = [
    ./work/default.nix
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

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults = {
    loginwindow.LoginwindowText = ''
      Tilhører Tænketanken for Digital Infrastruktur


    '';
  };
}
