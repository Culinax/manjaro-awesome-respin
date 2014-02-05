#!/bin/bash
# 
# brightness.sh
#
# $1 = up/down

steps=10

[[ "$1" = "up" ]] && xbacklight -inc "$steps"
[[ "$1" = "down" ]] && xbacklight -dec "$steps"

cards=()
for dir in /sys/class/backlight/*; do
    cards+=("${dir##*/}")
done

# Assuming there can't be more than 2 dirs and that acpi_video0 is never default
card="${cards[$(( ${#cards[@]} -1 ))]}"

maxbright=$(</sys/class/backlight/"$card"/max_brightness)
bright=$(</sys/class/backlight/"$card"/brightness)
perc=$(echo "$bright*100/$maxbright" | bc)
volnoti-show -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg "$perc"
