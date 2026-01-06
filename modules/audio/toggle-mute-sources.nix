{ lib, withSystem, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.toggle-mute-sources = pkgs.writeShellApplication {
        name = "toggle-mute-sources";
        runtimeInputs = with pkgs; [
          pulseaudio
          gawk
        ];
      };
    };

  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      toggle-mute-sources = withSystem pkgs.stdenv.hostPlatform.system (
        psArgs: psArgs.config.packages.toggle-mute-sources
      );
    in
    {
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, z, exec, ${lib.getExe toggle-mute-sources}"
      ];

      home.packages = [ toggle-mute-sources ];
    };
}
