{
  pkgs,
  ...
}:
{
  imports = [
    # ./work/default.nix
  ];

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
