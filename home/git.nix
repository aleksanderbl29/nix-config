{ ... }:
{
  programs.git = {
    enable = true;
    userEmail = "github@aleksanderbl.dk";
    userName = "aleksanderbl29";
    ignores = [ ".DS_Store" ];
    lfs.enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
}
