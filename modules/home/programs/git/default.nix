{ development, ... }:
{
  programs.git = {
    enable = true;
    userName = development.git.username;
    userEmail = development.git.email;

    extraConfig = {
      init.defaultBranch = development.git.defaultBranch;
    };
  };
}
