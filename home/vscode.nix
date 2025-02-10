{ pkgs, ... }: {
  programs.vscode = {
    enable = true;

    userSettings = {
      # Theme and icons
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.preferredLightColorTheme" = "Github Light Default";
      "workbench.preferredDarkColorTheme" = "Github Dark Default";
      "window.autoDetectColorScheme" = true;

      # More visuals
      "emptyIndent.highlightIndent" = true;
      "editor.minimap.maxColumn" = 75;

      # Smooth animations
      "editor.smoothScrolling" = true;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.list.smoothScrolling" = true;

      # Editor
      "editor.tabSize" = 2;

      # Git
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;

      # Copilot
      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = true;
        "markdown" = false;
      };
      "github.copilot.editor.enableAutoCompletions" = true;

      # Files
      "files.associations" = {
        "*.yml" = "yaml";
        "*.yaml" = "yaml";
      };
      "r.plot.useHttpgd" = true;
    };

    # Extension authors and names must be all lower-case.
    extensions = with pkgs.vscode-extensions;
      [
        github.copilot
        github.github-vscode-theme
        # bbenoist.nix
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        mechatroner.rainbow-csv
      ] ++ (with pkgs.vscode-marketplace; [
        pkief.material-icon-theme
        oderwat.indent-rainbow
      ]);
  };
}
