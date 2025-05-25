{
  user,
  utils,
  ...
}:
{
  imports = utils.getModulesFromDirRec ./programs;
  home = {
    username = user.username;
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "hx";
    };
  };
}
