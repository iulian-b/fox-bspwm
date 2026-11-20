#!/bin/sh
# =============================================================
# Author: haiduk
# Date:   01.10.2025 22:35
#
# Dualsense 5 controller module for polybar
#
# Licensed under GPL-3.0 license
# ----------------------------------------------------------------------------
# Hardware Validation
BT_CLASS_PATH="/sys/class/bluetooth"
[ -d "$BT_CLASS_PATH" ] || exit 0  # Silent exit if no Bluetooth hardware

# Config Handling
CONFIG_DIR="${HOME}/.config/bspwm"
read -r current_rice < "${CONFIG_DIR}"/.rice
config_file="${CONFIG_DIR}/rices/${current_rice}/config.ini"

# Color Extraction with Fallbacks
read_power_colors() {
    # Read both colors in single pass
    awk 'BEGIN {on=""; off=""}
       /^cyan =/ {on=$3; if (off != "") exit}
       /^grey =/ {off=$3; if (on != "") exit}
       END {print on " " off}' "$config_file"
}

# Power Check Function
get_bt_status() {
    # Check systemd service state
    systemctl is-active bluetooth.service >/dev/null 2>&1 || return 1

    # Check if controller is powered on
    INFO=$( dualsensectl info 2>&1 )
    if [ "$INFO" == "No device found" ]; then
        # OFF
        return 1
    else
        # ON
        return 0
    fi
}

# Battery check and icon set
function get_battery_icon {
    LEVEL="$(dualsensectl battery 2>&1 | awk '{print $1}')" # 1-100 
    STATE="$(dualsensectl battery 2>&1 | awk '{print $2}')" # charging/discharging
    
    if [ "$STATE" == "charging" ];
        # Is charging
        then echo "󰨢"
        break
    elif [[ "$LEVEL" -lt 25 ]]; 
        # Low battery
        then echo "󰝋"
        break
        # Normal        
    else echo "󰖺"
    fi
}

# Color config
if [ -f "$config_file" ]; then
    set -- $(read_power_colors)
    POWER_ON="$1"
    POWER_OFF="$2"
else  # Fallback colors if config missing
    POWER_ON="#ffffff"
    POWER_OFF="#666666"
fi

# Main output
if get_bt_status; then # Powered On
    BATTERY="$(dualsensectl battery 2>&1 | awk '{print $1}')"
    ICON=$(get_battery_icon)
    echo "%{F${POWER_ON}}${ICON}%{F-} ${BATTERY}%"
elif [ $? -eq 1 ]; then # Powered Off
    echo "%{F${POWER_OFF}}󰖻%{F-}"
fi

# Ensure clean exit for Polybar compatibility
exit 0
