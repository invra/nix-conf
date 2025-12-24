{
  flakeConfig,
  lib,
  pkgs,
  ...
}:
let
  useOldGit = flakeConfig ? development && flakeConfig.development ? git;

  useHg =
    flakeConfig ? development
    && flakeConfig.development ? scm
    && flakeConfig.development.scm ? mercurial;

  gitConfig =
    if useOldGit then
      lib.warnIf true
        "The config option development.git is deprecated. Please use development.scm.git instead."
        flakeConfig.development.git
    else if
      flakeConfig ? development && flakeConfig.development ? scm && flakeConfig.development.scm ? git
    then
      flakeConfig.development.scm.git
    else
      { };
in
{
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
    settings = {
      user = {
        name = gitConfig.username or "default-username";
        email = gitConfig.email or "default@example.com";
      };
      alias = {
        a = "add";
        lg = "lg1";
        p = "push -v";
        s = "status -s";
        c = "commit -m";
        b = "branch --all";
        co = "checkout -b";
        m = "commit --amend";
        fp = "git fetch --prune";
        la = "!git config -l | grep alias | cut -c 7-";
        ca = "!sh -c 'git add -A && git commit -m \"$1\" && git push' -";
        lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      };
      init.defaultBranch = gitConfig.defaultBranch or "main";
      core.quotepath = "off";
    };
  };

  programs.mercurial = lib.optionalAttrs useHg (
    with flakeConfig.development.scm;
    {
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
    }
  );

  home.packages = with pkgs; [
    glab
    gh
  ];
}
