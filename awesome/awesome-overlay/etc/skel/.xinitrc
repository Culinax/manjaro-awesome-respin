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
(sleep 2 && spacefm -d) &
(sleep 3 && udevil) &
(sleep 3 && conky) &

# Applications
(sleep 2 && volumeicon) &
(sleep 2 && clipit) &
(sleep 4 && nm-applet) &
(sleep 4 && urxvtc -e postinstall) & # Post Installation Script

# Window Manager
exec "$1"
