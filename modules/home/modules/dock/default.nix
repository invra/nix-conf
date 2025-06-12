{
  config,
  lib,
  unstable,
  ...
}:

with lib;

let
  cfg = config.local.dock;
  inherit (unstable) dockutil;
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
      (
        haveURIs="$(${dockutil}/bin/dockutil --list | ${unstable.coreutils}/bin/cut -f2)"
        wantURIs="$(
          ${lib.concatMapStringsSep "\n" (
            entry: "echo file://$(${unstable.coreutils}/bin/realpath '${entry.path}' | sed 's/ /%20/g')"
          ) cfg.entries}
        )"

        if ! diff -wu <(echo -n "$haveURIs") <(echo -n "$wantURIs") >/dev/null 2>&1; then
          ${dockutil}/bin/dockutil --no-restart --remove all >/dev/null 2>&1
          ${lib.concatMapStringsSep "\n" (
            entry:
            "${dockutil}/bin/dockutil --replacing 'Vesktop' --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options} >/dev/null 2>&1"
          ) cfg.entries}
          ${unstable.killall}/bin/killall Dock >/dev/null 2>&1
        fi
      ) >/dev/null 2>&1
    '';
  };
}
