#!/bin/bash

# Define paths
SCRIPT_DIR=$(dirname "$0")
USB_RESET_SCRIPT="$SCRIPT_DIR/usb_reset"
USB_PATH="/dev/bus/usb/001/003"
LOG_FILE="$SCRIPT_DIR/reset_script.log"

while true; do
  # Get WiFi device status
  wifi_status=$(nmcli device show wlx90de80ae8d61 | awk -F": " '/GENERAL.STATE/ {gsub(/^[ \t]+|[()0-9]+/,"",$2); sub(/^[ \t]+/, "", $2); print $2}')

  if [ "$wifi_status" == "connected" ]; then
    echo "$(date): A WiFi device was found and is connected." >> "$LOG_FILE"
  elif [ "$wifi_status" == "disconnected" ]; then
    echo "$(date): A WiFi device was found, but it is disconnected. Running usb_reset..." >> "$LOG_FILE"
    "$USB_RESET_SCRIPT" "$USB_PATH"
  else
    echo "$(date): No WiFi device found on $USB_PATH" >> "$LOG_FILE"
  fi

  sleep 120 # Wait for 2 minutes
done
