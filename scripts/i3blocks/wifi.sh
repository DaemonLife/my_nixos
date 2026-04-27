#!/usr/bin/env bash

WIFI_INFO=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes')

if [[ -z "$WIFI_INFO" ]]; then
    echo "wifi off"
fi

SSID=$(echo "$WIFI_INFO" | cut -d: -f2)
SIGNAL=$(echo "$WIFI_INFO" | cut -d: -f3)

# echo "$SSID ($SIGNAL%)"
echo "wifi: $SIGNAL%"

case $BLOCK_BUTTON in
    1) wifi on && alacritty -e "nmtui" ;;
    3) wifi off ;;
esac
