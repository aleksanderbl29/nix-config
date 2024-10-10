{ nixpkgs, nix-homebrew, homebrew-core, homebrew-cask , ...}:
{
  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "aleksanderbang-larsen";

    # Automatically migrate existing Homebrew installations
    autoMigrate = true;
  };
}