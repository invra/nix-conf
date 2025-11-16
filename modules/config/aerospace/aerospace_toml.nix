{
  pkgs,
  ...
}:
let
  gaps = 6;
in
''
  accordion-padding = 30
  after-startup-command = [
    'exec-and-forget ${pkgs.sketchierbar}/bin/sketchierbar',
    'exec-and-forget ${pkgs.ffm}/bin/ffm'
  ]
  automatically-unhide-macos-hidden-apps = true
  default-root-container-layout = "tiles"
  default-root-container-orientation = "auto"
  enable-normalization-flatten-containers = true
  enable-normalization-opposite-orientation-for-nested-containers = true
  exec-on-workspace-change = ['${pkgs.bashInteractive}/bin/bash', '-c', '${pkgs.sketchierbar}/bin/sketchierbar --trigger aerospace_change $AEROSPACE_FOCUSED_WORKSPACE']
  on-focus-changed = []
  on-window-detected = []
  start-at-login = false

  [gaps.inner]
  horizontal = ${builtins.toString gaps}
  vertical = ${builtins.toString gaps}

  [gaps.outer]
  bottom = ${builtins.toString gaps}
  left = ${builtins.toString gaps}
  right = ${builtins.toString gaps}
  top = ${builtins.toString (gaps + 2)}

  [key-mapping]
  preset = "qwerty"

  [mode.main.binding]
  alt-enter = "macos-native-fullscreen"
  alt-h = "focus left"
  alt-j = "focus down"
  alt-k = "focus up"
  alt-l = "focus right"
  alt-space = ["layout floating tiling", "mode main"]
  cmd-1 = "workspace 1"
  cmd-2 = "workspace 2"
  cmd-3 = "workspace 3"
  cmd-4 = "workspace 4"
  cmd-5 = "workspace 5"
  cmd-6 = "workspace 6"
  cmd-7 = "workspace 7"
  cmd-8 = "workspace 8"
  cmd-9 = "workspace 9"
  cmd-alt-h = []
  cmd-enter = ["exec-and-forget open -n ${pkgs.alacritty}/Applications/Alacritty.app", "mode main"]
  cmd-esc = ["reload-config", "mode main"]
  cmd-h = []
  cmd-shift-1 = ["move-node-to-workspace 1", "workspace 1"]
  cmd-shift-2 = ["move-node-to-workspace 2", "workspace 2"]
  cmd-shift-3 = ["move-node-to-workspace 3", "workspace 3"]
  cmd-shift-4 = ["move-node-to-workspace 4", "workspace 4"]
  cmd-shift-5 = ["move-node-to-workspace 5", "workspace 5"]
  cmd-shift-6 = ["move-node-to-workspace 6", "workspace 6"]
  cmd-shift-7 = ["move-node-to-workspace 7", "workspace 7"]
  cmd-shift-8 = ["move-node-to-workspace 8", "workspace 8"]
  cmd-shift-9 = ["move-node-to-workspace 9", "workspace 9"]

  [workspace-to-monitor-force-assignment]
  1 = "1"
  2 = "1"
  3 = "1"
  4 = "2"
  5 = "2"
  6 = "2"
  7 = "3"
  8 = "3"
  9 = "3"
''
