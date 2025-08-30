{
  flakeConfig,
  ...
}:
with flakeConfig.development.scm;
{
  programs.mercurial = {
    enable = mercurial.enable or false;
    userName = mercurial.username;
    userEmail = mercurial.email;
    extraConfig = {
      init.defaultBranch = mercurial.defaultBranch;
      core.quotepath = "off";
    };
    aliases = {
      p = "push";
      c = "commit";
      a = "commit --amend";
    };
  };
}
