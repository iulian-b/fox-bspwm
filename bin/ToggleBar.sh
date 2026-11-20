# Configuration
read -r current_rice <"$HOME"/.config/bspwm/.rice
THEME_CONFIG="$HOME/.config/bspwm/rices/$current_rice/theme-config.bash"
eww_bar_path="$HOME/.config/bspwm/rices/$current_rice/bar"

# Get padding value from theme-config.bash
get_paddings() {
    awk -F'"' '
        /^TOP_PADDING/    { top = $2 }
        /^BOTTOM_PADDING/ { bottom = $2 }
        /^LEFT_PADDING/   { left = $2 }
        /^RIGHT_PADDING/  { right = $2 }
        END { print top, bottom, left, right }
    ' "$THEME_CONFIG"
}

set_padding() {
    bspc config top_padding "$1"
    bspc config bottom_padding "$2"
    bspc config left_padding "$3"
    bspc config right_padding "$4"
}

toggle_bars() {
	bot=$(pgrep -f sys-bar-bot)
    if [ "$1" = "hide" ]; then
	    bspc config bottom_padding 2
        polybar-msg -p $bot cmd hide
    else
        set_padding $(get_paddings)
        polybar-msg -p $bot cmd show
    fi
}

case "$1" in
    -h|--hide)   toggle_bars hide ;;
    -u|--unhide) toggle_bars unhide ;;
    *)	echo "Usage: $0 [-h|--hide] [-u|--unhide]" ;;
esac
