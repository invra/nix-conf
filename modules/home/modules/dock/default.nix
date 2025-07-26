{
  config,
  lib,
  pkgs,
  ...
}:
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
      default = { };
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
      home.activation.darwinDock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        #!/bin/bash
        (
          haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2 | ${pkgs.coreutils}/bin/sort)"
          wantURIs=""
          ${lib.optionalString (cfg.entries != []) ''
            wantURIs="$(
              {
                ${lib.concatMapStringsSep "\n" (
                  entry: ''
                    if [[ -z "${entry.path or ""}" || -z "${entry.section or ""}" ]]; then
                      echo "Error: Invalid entry in cfg.entries (missing path or section): ${builtins.toJSON entry}" >&2
                      exit 1
                    fi
                    path="$(${pkgs.coreutils}/bin/realpath "${entry.path}")"
                    if [[ "$path" =~ home-manager-applications ]]; then
                      path="$(${pkgs.coreutils}/bin/realpath "$path")"
                    fi
                    if [[ ! "$path" =~ \.app$ ]]; then
                      echo "Error: Path '$path' is not an application bundle" >&2
                      exit 1
                    fi
                    echo "file://$path/"
                  ''
                ) cfg.entries}
              } | ${pkgs.coreutils}/bin/sort
            )"
          ''}

          if ! diff -wu <(echo -n "$haveURIs") <(echo -n "$wantURIs") >/dev/null 2>&1; then
            echo "Dock URIs differ, updating Dock" >&2
            ${dockutil}/bin/dockutil --no-restart --remove all >/dev/null 2>&1
            ${lib.optionalString (cfg.entries != []) ''
              ${lib.concatMapStringsSep "\n" (
                entry: ''
                  if [[ -z "${entry.path or ""}" || -z "${entry.section or ""}" ]]; then
                    echo "Error: Invalid entry in cfg.entries (missing path or section): ${builtins.toJSON entry}" >&2
                    exit 1
                  fi
                  resolved_path="$(${pkgs.coreutils}/bin/realpath "${entry.path}")"
                  if [[ "$resolved_path" =~ home-manager-applications ]]; then
                    resolved_path="$(${pkgs.coreutils}/bin/realpath "$resolved_path")"
                  fi
                  if [[ ! "$resolved_path" =~ \.app$ ]]; then
                    echo "Error: Path '$resolved_path' is not an application bundle" >&2
                    exit 1
                  fi
                  ${dockutil}/bin/dockutil --no-restart --add "$resolved_path" --section ${entry.section} ${entry.options or ""} >/dev/null 2>&1
                ''
              ) cfg.entries}
            ''}
            ${pkgs.killall}/bin/killall Dock >/dev/null 2>&1
          else
            echo "Dock URIs are identical, no update needed" >&2
          fi
        ) >/dev/null 2>&1
      '';
    })
  ];
}
