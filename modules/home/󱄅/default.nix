{ user, nixpkgs, ... }:
let
  utils = import ../utils.nix { inherit (nixpkgs) lib; };
in
{
  imports = utils.getModulesFromDirRec ./programs;
  home = {
    username = user.username;
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };
}
