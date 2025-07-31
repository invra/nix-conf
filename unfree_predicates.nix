{ lib, ... }:
(
pkg:
builtins.elem (lib.getName pkg) [
  "davinci-resolve"
  "steam-unwrapped"
  "steam_osx"
  "discord"
  "tart"
  "betterdisplay"
  "raycast"
  "steam"
  "bitwig-studio-unwrapped"
  "parsec-bin"
  "mongodb-compass"
  "postman"
  "vscode"
  "teams"
  "nvidia-x11"
  "nvidia-settings"
]
)
