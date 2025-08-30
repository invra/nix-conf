{
  flakeConfig,
  lib,
  ...
}:
let
  useOldGit = flakeConfig ? development && flakeConfig.development ? git;

  useHg = flakeConfig ? development
    && flakeConfig.development ? scm
    && flakeConfig.development.scm ? mercurial;

  gitConfig =
    if useOldGit then
      lib.warnIf true
        "The config option development.git is deprecated. Please use development.scm.git instead."
        flakeConfig.development.git
    else if flakeConfig ? development && flakeConfig.development ? scm && flakeConfig.development.scm ? git then
      flakeConfig.development.scm.git
    else
      {};
in
{
  imports = [
    ./gh
    ./glab
    ./lazygit
  ];

  assertions = [
    {
      assertion = !(useOldGit && useHg);
      message = ''
        You have specified development.scm.mercurial whilst using development.git.
        Please use development.scm.git instead.
      '';
    }
  ];

  programs.git = {
    enable = true;
    userName = gitConfig.username or "default-username";
    userEmail = gitConfig.email or "default@example.com";
    extraConfig = {
      init.defaultBranch = gitConfig.defaultBranch or "main";
      core.quotepath = "off";
    };
    aliases = {
      p = "push -v";
      c = "commit";
      a = "commit --amend";
    };
  };
}
