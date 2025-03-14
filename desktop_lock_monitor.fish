#!/usr/bin/env fish

pgrep -x dbus-monitor >/dev/null || dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver'" | fish /home/andrei/log_lockscreen.fish &