{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "github@aleksanderbl.dk";
        name = "aleksanderbl29";
      };
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
    };
    ignores = [ ".DS_Store" ];
    lfs.enable = true;
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
  };

  home.packages = with pkgs; [
    libgit2
  ];
}
