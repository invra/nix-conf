{ development, ... }:
with development.git;
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
    };
  };

}
