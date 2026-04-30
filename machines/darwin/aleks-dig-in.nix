{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  ai-tools = inputs.nix-ai-tools.packages.${pkgs.system};
in
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
      ai-tools.cursor-agent
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
