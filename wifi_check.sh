#!/bin/bash

# Define paths
SCRIPT_DIR=$(dirname "$0")
USB_RESET_SCRIPT="$SCRIPT_DIR/usb_reset"
USB_PATH="/dev/bus/usb/001/003"
LOG_FILE="$SCRIPT_DIR/reset_script.log"

while true; do
  # Run nmcli command and check for WiFi connection status
  wifi_status=$(nmcli device show | awk -v devtype="wifi" '$2 == devtype {print $NF}')

  if [ "$wifi_status" == "disconnected" ]; then
    echo "$(date): A WiFi device was found, but it is disconnected. Running usb_reset..." >> "$LOG_FILE"
    "$USB_RESET_SCRIPT" "$USB_PATH"
  elif [ "$wifi_status" == "connected" ]; then
    echo "$(date): A WiFi device was found and is connected." >> "$LOG_FILE"
  else
    echo "$(date): No WiFi device found on $USB_PATH" >> "$LOG_FILE"
  fi

  sleep 120 # Wait for 2 minutes
done