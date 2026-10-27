{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "github@aleksanderbl.dk";
        name = "aleksanderbl29";
        signingkey = "~/.ssh/github.pub";
      };
      gpg.format = "ssh";
      commit.gpgsign = true;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      url."git@github.com:".insteadOf = "https://github.com/";
      safe.directory = "/etc/nixos";
    };
    ignores = [ ".DS_Store" ];
    lfs.enable = true;
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    libgit2
  ];
}
