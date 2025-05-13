{ development, ... }:
with development.git;
{
  imports = [./gh ./glab];
  programs.git = {
    enable = true;
    userName = username;
    userEmail = email;
    extraConfig = {
      init.defaultBranch = defaultBrach;
    };
  };

}
