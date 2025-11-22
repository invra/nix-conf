#!/bin/sh
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
systemctl --user restart xdg-desktop-portal
systemctl --user restart xdg-desktop-portal-wlr
