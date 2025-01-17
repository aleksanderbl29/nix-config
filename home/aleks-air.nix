{ ... }: {
  programs.vscode = {
    enable = true;

    userSettings = {
      "workbench.iconTheme": material-icon-theme;
    };
  }
}