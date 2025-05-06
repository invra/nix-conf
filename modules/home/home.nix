{
  development,
  nixpkgs,
  user,
  pkgs,
  ...
}:
let
  utils = import ./utils.nix {lib = nixpkgs.lib;};

in
{
  imports = utils.getModulesFromDirsRec [ ./system ./programs ];

  home = {
    username = user.username;
    homeDirectory = "/home/" + user.username;
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };
}
