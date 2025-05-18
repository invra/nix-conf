{ unstable, desktop, ... }:
let
  hyprland = desktop.hyprland;

  monitors = builtins.map (monitor: {
    name = monitor.name;
    resolution = monitor.resolution;
    refreshRate = monitor.refreshRate;
    position = monitor.position;
    scale = monitor.scale;
  }) hyprland.monitors;
in
{
  imports = [
    ./mako
    ./waybar
  ];
  stylix.targets.hyprland.enable = false;

  home.packages = with unstable; [
    playerctl
    hyprshot
  ];

  wayland.windowManager.hyprland = {
    enable = hyprland.enable;

    settings = {
      monitor = builtins.map (
        monitor:
        "${monitor.name},${monitor.resolution}@${builtins.toString monitor.refreshRate},${monitor.position},${builtins.toString monitor.scale}"
      ) monitors;

      # Auto-launching
      exec-once = [
        "swww-daemon &"
        "waybar &"
        "mako &"
      ];

      # General settings
      general = {
        gaps_in = 2.5;
        gaps_out = 5;
        border_size = 3;
        "col.active_border" = "rgb(ebbcba) rgb(ebbcba) 45deg";
        "col.inactive_border" = "rgba(00000000)";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1;
        inactive_opacity = 0.8;
        shadow = {
          enabled = false;
        };
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
        };
      };

      animations = {
        enabled = true;
      };

      # Inputs (keyboard & mouse)
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0.5;
        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      render = {
        explicit_sync = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Keybinds
      bind = [
        "SUPER, Return, exec, ghostty"
        "SUPER, S, exec, spotify"
        "SUPER, Z, exec, zeditor"
        "SUPER, D, exec, vesktop"
        "SUPER, T, exec, thunar"
        "SUPER, V, exec, clipman pick -t rofi"
        "SUPER, B, exec, zen"
        "SUPER, Q, killactive"
        "SUPER ALT SHIFT, Q, exit"
        "SUPER LSHIFT, S, exec, hyprshot -m region --clipboard-only"
        "SUPER LSHIFT, Space, togglefloating"
        "SUPER, C, togglesplit"
        "ALT, Return, fullscreen"
        "SUPER, 1, workspace, 1"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER SHIFT, 5, movetoworkspace, 5"
      ];

      bindl = [
        " , XF86AudioPrev, exec, playerctl previous"
        "ALT LSHIFT, F10, exec, playerctl previous"
        " , XF86AudioPlay, exec, playerctl play-pause"
        "ALT LSHIFT, F11, exec, playerctl play-pause"
        " , XF86AudioNext, exec, playerctl next"
        "ALT LSHIFT, F12, exec, playerctl next"
      ];

      bindr = [
        "SUPER, Space, exec, bash -c 'pkill rofi  || rofi -show drun'"
      ];

      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      binde = [
        " , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        " , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      windowrulev2 = [
        "pin, title:Picture-in-Picture"
        "float, title:Picture-in-Picture"
        "size 640 360, title:Picture-in-Picture"
        "pin, title:Picture-in-Picture"
      ];
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
