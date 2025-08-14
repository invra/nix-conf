{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.airspace;
in
{
  options = {
    services.airspace = with lib.types; {
      enable = lib.mkEnableOption "AeroSpace window manager";
      package = lib.mkPackageOption pkgs "aerospace" { };

      settings = lib.mkOption {
        type = path;
        default = "";
        description = "Path to the TOML configuration file";
      };
    };
  };

  config = (
    lib.mkIf (cfg.enable) {
      environment.systemPackages = [ cfg.package ];

      launchd.user.agents.aerospace = {
        command =
          "${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
          + (lib.optionalString (cfg.settings != { }) " --config-path ${cfg.settings}");
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
        managedBy = "services.aerospace.enable";
      };
    }
  );
}
