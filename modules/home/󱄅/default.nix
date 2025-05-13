{
  nixpkgs,
  ...
}:
let
  utils = import ./utils.nix { inherit (nixpkgs) lib; };
in
{
  imports = utils.getModulesFromDirRec ./programs;
  home = {
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };
}
