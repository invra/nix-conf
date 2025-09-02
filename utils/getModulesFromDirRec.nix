{
  lib,
  ...
}:
let
  getModulesFromDirRec = dir: isRoot:
    lib.lists.unique (
      lib.lists.flatten (
        lib.mapAttrsToList (
          name: type:
            if type == "regular" then
              if isRoot then
                lib.optional (lib.strings.hasSuffix ".nix" name && name != "default.nix")
                  (lib.path.append dir name)
              else
                lib.optional (name == "default.nix")
                  (lib.path.append dir name)
            else if type == "directory" then
              getModulesFromDirRec (lib.path.append dir name) false
            else
              [ ]
        ) (builtins.readDir dir)
      )
    );
in
getModulesFromDirRec
