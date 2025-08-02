#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.color=0xff26233a label.shadow.drawing=on background.border_width=0
else
  sketchybar --set "$NAME" background.color=0xff1f1d2e label.shadow.drawing=off background.border_width=0
fi