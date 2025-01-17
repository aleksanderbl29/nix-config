{ ... }:
let
  bentobox = "org.friendlyventures.BentoBox.plist";
in
{
  system.activationScripts.copyPreferences = {
    text = ''
      echo "Copying bentobox preferences to /Library/Preferences/"
      SOURCE="./dots/${ bentobox }"
      DEST="/Library/Preferences/${ bentobox }"

      # Ensure we have root permissions
      if [ ! -w "/Library/Preferences" ]; then
        echo "Requesting root permissions to copy file"
        sudo mkdir -p "/Library/Preferences"
      fi

      # Copy file and set proper permissions
      sudo cp "$SOURCE" "$DEST"
      sudo chown root:admin "$DEST"
      sudo chmod 644 "$DEST"
    '';
  };
}