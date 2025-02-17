{ pkgs, ... }:
let
  spotify-notifications = pkgs.stdenv.mkDerivation {
    name = "spotify-notifications";
    version = "0.6.0";

    src = pkgs.fetchzip {
      url = "https://github.com/aleksanderbl29/Spotify-Notifications/releases/download/release-2/Spotify-Notifications.zip";
      sha256 = "sha256-GQh4ZHFrB3flj85ElEGysN4EzWf45f1hdFcohO+D9FA=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out/Applications
      cp -r "Spotify Notifications.app" $out/Applications/
    '';

    meta = {
      description = "Spotify track change notifications for macOS";
      platforms = [ pkgs.stdenv.hostPlatform.system ];
    };
  };
in
{
  environment.systemPackages = [
    spotify-notifications
  ];
}
