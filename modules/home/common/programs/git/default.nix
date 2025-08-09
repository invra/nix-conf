{
  flakeConfig,
  ...
}:
with flakeConfig.development.git;
{
  imports = [
    ./gh
    ./glab
    ./lazygit
  ];
  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
    extraConfig = {
      init.defaultBranch = defaultBranch;
      core.quotepath = "off";
    };
    aliases = {
      p = "push -v";
      c = "commit";
      a = "commit --amend";
    };
  };
}
