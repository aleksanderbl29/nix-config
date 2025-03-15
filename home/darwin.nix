{ ... }:
let
  user = "aleksander";
  od_loc = "/Users/${user}/Library/CloudStorage/OneDrive-AarhusUniversitet";
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
        posit = "open -a 'Positron' .";

        # Folder navigation
        onedrive = "cd ${od_loc}";
        g-drive = "cd '${cloud_stor}/GoogleDrive-aleksanderbl@live.dk/Mit drev/'";
        dropbox = "cd '${cloud_stor}/Dropbox'";
        # us_pres_elec = "cd '${ od_loc }/Afsluttet/7 - US Presidential Election/US_pres_elec'";
        pol_geo_ds = "cd '${od_loc}/Afsluttet/7 - Politisk geo-data-science med R/pol_geo_ds'";
        t7 = "cd '/Volumes/T7 Shield/developer'";
      };
    };
  };
}
