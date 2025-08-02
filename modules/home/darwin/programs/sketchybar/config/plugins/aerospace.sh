#!/usr/bin/env bash

focused="$AEROSPACE_FOCUSED_WORKSPACE"

for sid in $(aerospace list-workspaces --all); do
  if [ "$sid" = "$focused" ]; then
    sketchybar --set space."$sid" icon.color=0xffeb6f92
  else
    sketchybar --set space."$sid" icon.color=0xffc4a7e7
  fi
done
