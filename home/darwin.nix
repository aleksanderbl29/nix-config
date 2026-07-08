{ lib, ... }:
let
  user = "aleksander";
  cloud_stor = "/Users/${user}/Library/CloudStorage";
in
{
  # Ghostty configuration
  home.file.".config/ghostty/config".source = ../dots/ghostty;

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        # R on mac specific
        ropen = "open *.Rproj";
        # posit = "open -a 'Positron' .";

        # Folder navigation
        g-drive = "cd '${cloud_stor}/GoogleDrive-aleksanderbl@live.dk/Mit drev/'";
        dropbox = "cd '${cloud_stor}/Dropbox'";
        # us_pres_elec = "cd '${ od_loc }/Afsluttet/7 - US Presidential Election/US_pres_elec'";
        t7 = "cd '/Volumes/T7 Shield/developer'";
      };
    };
  };

  # Apply system settings
  home.activation = {
    activateSettings = lib.hm.dag.entryAfter [ "home-manager" ] ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
}
