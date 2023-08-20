#!/bin/bash

# Define paths
SCRIPT_DIR=$(dirname "$0")
USB_RESET_SCRIPT="$SCRIPT_DIR/usb_reset"
USB_PATH="/dev/bus/usb/001/006"
LOG_FILE="$SCRIPT_DIR/reset_script.log"

while true; do
  # Run nmcli command and check for "disconnected" keyword
  if nmcli device | grep -q "disconnected"; then
      echo "$(date): No connected device found. Running usb_reset..." >> "$LOG_FILE"
      "$USB_RESET_SCRIPT" "$USB_PATH"
  else
      echo "$(date): A connected device was found." >> "$LOG_FILE"
  fi
  sleep 120 # Wait for 30 seconds
done
