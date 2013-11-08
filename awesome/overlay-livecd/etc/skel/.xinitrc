#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Configuration
xrdb -merge ~/.Xresources

# Daemons
(sleep 1 && urxvtd -q -o -f) &
(sleep 1 && unagi) &
(sleep 1 && volnoti) &
(sleep 2 && thunar --daemon) &
(sleep 3 && conky) &

# Applications
sleep 1 && xdg_menu --format awesome  >${HOME}/.config/awesome/menu.lua
(sleep 2 && volumeicon) &
(sleep 2 && clipit) &
(sleep 4 && nm-applet) &

# Window Manager
exec "$1"
