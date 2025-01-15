{ ... }: {
  programs.git = {
    enable = true;
    userEmail = "github@aleksanderbl.dk";
    userName = "aleksanderbl29";
    ignores = [ ".DS_Store" ];
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
}