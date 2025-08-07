{
  custils,
  flakeConfig,
  ...
}:
{
  imports = custils.getModulesFromDirRec ./programs;
  home = {
    username = flakeConfig.user.username;
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "hx";
    };
  };
}
