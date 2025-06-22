{ ... }:
{
  programs.git = {
    enable = true;
    userEmail = "github@aleksanderbl.dk";
    userName = "aleksanderbl29";
    ignores = [ ".DS_Store" ];
    lfs.enable = true;
    difftastic = {
      enable = true;
      enableAsDifftool = true;
    };
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
    };
  };
}
