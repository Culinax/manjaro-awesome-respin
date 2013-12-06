#!/bin/bash
# 
# brightness.sh
#
# $1 = up/down
# $2 = steps to increase/decrease (%)

[[ "$1" = "up" ]] && xbacklight -inc "$2"
[[ "$1" = "down" ]] && xbacklight -dec "$2"

CARDS=()
for DIR in /sys/class/backlight/*; do
    CARDS+=("${DIR##*/}")
done

# Assuming there can't be more than 2 dirs and that acpi_video0 is never default
CARD="${CARDS[$(( ${#CARDS[@]} -1 ))]}"

MAXBRIGHT=$(</sys/class/backlight/"$CARD"/max_brightness)
BRIGHT=$(</sys/class/backlight/"$CARD"/brightness)
PERC=$(echo "$BRIGHT*100/$MAXBRIGHT" | bc)
volnoti-show -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg "$PERC"
