{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.targets.darwin.dock;
  isAppDrawerCompliant = import ./os_vers { inherit pkgs; };
  dockutil = pkgs.dockutil;
in
{
  options = {
    targets.darwin.dock = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to set up Dock entries.";
      };

      entries = mkOption {
        type = types.listOf (types.submodule {
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
        });
        default = [
          {
            path =
              if isAppDrawerCompliant then "/System/Applications/Apps.app" else "/Applications/Launchpad.app";
          }
          { path = "/Applications/Safari.app"; }
          { path = "/System/Applications/Messages.app"; }
          { path = "/System/Applications/Mail.app"; }
          { path = "/System/Applications/Maps.app"; }
          { path = "/System/Applications/Photos.app"; }
          { path = "/System/Applications/FaceTime.app"; }
          { path = "/System/Applications/Calendar.app"; }
          { path = "/System/Applications/Contacts.app"; }
          { path = "/System/Applications/Reminders.app"; }
          { path = "/System/Applications/Notes.app"; }
          { path = "/System/Applications/Freeform.app"; }
          { path = "/System/Applications/TV.app"; }
          { path = "/System/Applications/Music.app"; }
          { path = "/System/Applications/News.app"; }
          { path = "/System/Applications/System Settings.app"; }
        ];
        description = "List of Dock entries.";
      };
    };

    local.dock = mkOption {
      type = types.attrs;
      default = {};
      internal = true;
    };
  };

  config = mkMerge [
    (mkIf (config.local.dock ? enable && config.local.dock.enable) {
      assertions = [
        {
          assertion = false;
          message = "local.dock is no longer supported. Please use targets.darwin.dock";
        }
      ];
    })

    (mkIf cfg.enable {
      home.activation.dockSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        (
          haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
          wantURIs="$(
            ${lib.concatMapStringsSep "\n" (
              entry: "echo file://$(${pkgs.coreutils}/bin/realpath '${entry.path}' | sed 's/ /%20/g')"
            ) cfg.entries}
          )"

          if ! diff -wu <(echo -n "$haveURIs") <(echo -n "$wantURIs") >/dev/null 2>&1; then
            ${dockutil}/bin/dockutil --no-restart --remove all >/dev/null 2>&1
            ${lib.concatMapStringsSep "\n" (
              entry:
              "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options} >/dev/null 2>&1"
            ) cfg.entries}
            ${pkgs.killall}/bin/killall Dock >/dev/null 2>&1
          fi
        ) >/dev/null 2>&1
      '';
    })
  ];
}
