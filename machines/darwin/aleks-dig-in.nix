{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # ./work/default.nix
    ../common/darwin/system.nix
  ];

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
    systemPackages = with pkgs; [
    ];
  };

  system.keyboard = lib.mkForce {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults = lib.mkForce {
    loginwindow.LoginwindowText = ''
      Tilhører 
      Tænketanken for Digital Infrastruktur

    '';
  };
}
