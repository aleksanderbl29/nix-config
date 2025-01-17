{ username, ... }:
let
  bentobox = "org.friendlyventures.BentoBox.plist";
in
{
  system.activationScripts.copyPreferences = {
    text = ''
      echo "Copying bentobox preferences to user Library/Preferences"
      SOURCE="./dots/${ bentobox }"
      DEST="/Users/${username}/Library/Preferences/${ bentobox }"

      # Ensure the directory exists
      mkdir -p "/Users/${username}/Library/Preferences"

      # Copy file and set proper permissions
      cp "$SOURCE" "$DEST"
      chown ${username}:staff "$DEST"
      chmod 644 "$DEST"
    '';
  };
}