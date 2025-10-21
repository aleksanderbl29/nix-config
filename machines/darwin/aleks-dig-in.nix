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
      bruno
      air-formatter
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

  networking = {
    computerName = "aleks-dig-in";
    hostName = "aleks-dig-in";
  };
}
