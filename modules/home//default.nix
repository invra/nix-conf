{
  nixpkgs,
  user,
  ...
}:
let
  utils = import ./utils.nix { inherit (nixpkgs) lib; };
in
{
  imports = utils.getModulesFromDirsRec [
    ./misc
    ./programs
  ];

  home = {
    username = user.username;
    homeDirectory = "/home/${user.username}";
  };
}
