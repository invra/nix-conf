{
  custils,
  configTOML,
  ...
}:
{
  imports = custils.getModulesFromDirRec ./programs;
  home = {
    username = configTOML.user.username;
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "hx";
    };
  };
}
