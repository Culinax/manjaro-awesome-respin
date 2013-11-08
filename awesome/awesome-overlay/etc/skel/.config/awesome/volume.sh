#!/bin/bash
#
# volume.sh
# 
# $1 = up/down/mute
# $2 = steps to increase/decrease (%)

[[ "$1" = "up" ]]   && amixer set Master "$2"%+
[[ "$1" = "down" ]] && amixer set Master "$2"%-
[[ "$1" = "mute" ]] && amixer set Master toggle

VOL=$(amixer get Master | grep Mono: | sed 's|[^[]*\[\([0-9]*\).*|\1|')
[[ $(amixer get Master | grep "\[off\]") ]] && volnoti-show -m "$VOL" && exit
volnoti-show "$VOL"
