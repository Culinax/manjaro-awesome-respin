#!/bin/bash
#
# volume.sh
# 
# $1 = up/down/mute

steps=2

[[ "$1" = "up" ]]   && amixer set Master "$steps"%+
[[ "$1" = "down" ]] && amixer set Master "$steps"%-
[[ "$1" = "mute" ]] && amixer set Master toggle

vol=$(amixer get Master | grep Mono: | sed 's|[^[]*\[\([0-9]*\).*|\1|')
[[ $(amixer get Master | grep "\[off\]") ]] && volnoti-show -m "$vol" && exit
volnoti-show "$vol"
