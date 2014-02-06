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
sleep 1 && compton -b
(sleep 1 && volnoti) &
(sleep 2 && spacefm -d) &
(sleep 3 && udevil) &
(sleep 3 && conky) &

# Applications
(sleep 2 && volumeicon) &
(sleep 2 && clipit) &
sleep 4 && dex -ae Awesome

# Window Manager
/opt/livecd/disable-dpms
exec awesome
