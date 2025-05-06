{lib, ...}:
rec {
  getModulesFromDirRec =
    dir:
    if lib.pathExists (lib.path.append dir "default.nix") then
      [ dir ]
    else
      lib.lists.unique (
        lib.lists.flatten (
          lib.mapAttrsToList (
            name: type:
            (lib.optional (type == "regular" && lib.strings.hasSuffix ".nix" name) (lib.path.append dir name))
            ++ (lib.optional (type == "directory") (getModulesFromDirRec (lib.path.append dir name)))
          ) (builtins.readDir dir)
        )
      );

    getModulesFromDirsRec =
      dirs:
      lib.lists.unique (lib.lists.flatten (builtins.map getModulesFromDirRec dirs));
}
