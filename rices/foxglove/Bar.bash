# This file launch the bar/s
#for mon in $(polybar --list-monitors | cut -d":" -f1); do
#	(
#    MONITOR=$mon polybar -q cyn-bar -c "${HOME}"/.config/bspwm/rices/"${RICE}"/config.ini &
#	MONITOR=$mon polybar -q cyn-bar2 -c "${HOME}"/.config/bspwm/rices/"${RICE}"/config.ini &
#   )
#done
mon="DisplayPort-0"
MONITOR=$mon polybar -q sys-bar-top -c "${HOME}"/.config/bspwm/rices/"${RICE}"/config.ini &
MONITOR=$mon polybar -q sys-bar-bot -c "${HOME}"/.config/bspwm/rices/"${RICE}"/config.ini &