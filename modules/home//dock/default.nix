{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.local.dock;
  inherit (pkgs) dockutil;
in
{
  options = {
    local.dock.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to set up Dock entries.";
    };

    local.dock.entries = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            path = mkOption {
              type = types.str;
              description = "Path to the app or file to add to the Dock.";
            };
            section = mkOption {
              type = types.str;
              default = "apps";
              description = "Dock section: apps, others, etc.";
            };
            options = mkOption {
              type = types.str;
              default = "";
              description = "Extra options to pass to dockutil.";
            };
          };
        }
      );
      default = [ ];
      description = "List of Dock entries.";
    };
  };

  config = mkIf cfg.enable {
    home.activation.dockSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Setting up the Dock..."
      haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
      wantURIs="$(
        ${lib.concatMapStringsSep "\n" (
          entry: "echo file://$(${pkgs.coreutils}/bin/realpath '${entry.path}' | sed 's/ /%20/g')"
        ) cfg.entries}
      )"

      if ! diff -wu <(echo -n "$haveURIs") <(echo -n "$wantURIs") >&2 ; then
        echo "Resetting Dock."
        ${dockutil}/bin/dockutil --no-restart --remove all
        ${lib.concatMapStringsSep "\n" (
          entry:
          "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}"
        ) cfg.entries}
        ${pkgs.killall}/bin/killall Dock
      else
        echo "Dock already correct, skipping."
      fi
    '';
  };
}
