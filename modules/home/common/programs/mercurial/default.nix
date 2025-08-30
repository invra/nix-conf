{
  flakeConfig,
  ...
}:
with flakeConfig.development.scm;
{
  programs.mercurial = {
    enable = mercurial.enable or false;
    userName = mercurial.username or "default-username";
    userEmail = mercurial.email or "default@example.com";
    extraConfig = {
      init.defaultBranch = mercurial.defaultBranch or "main";
    };
    aliases = {
      p = "push";
      c = "commit";
      a = "commit --amend";
    };
  };
}
