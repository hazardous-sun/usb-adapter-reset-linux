#!/bin/bash

# Define paths
SCRIPT_DIR=$(dirname "$0")
USB_RESET_SCRIPT="$SCRIPT_DIR/usb_reset"
USB_PATH="/dev/bus/usb/001/006"
LOG_FILE="$SCRIPT_DIR/reset_script.log"

while true; do
  # Run nmcli command and check for "disconnected" keyword
  if nmcli device | grep 'wifi' -q | awk '$3 == "disconnected" { print $3 }' == "disconected"; then
      echo "$(date): A connected device was found, but it is disconnected. Running usb_reset..." >> "$LOG_FILE"
            "$USB_RESET_SCRIPT" "$USB_PATH"
  # Run nmcli command and check for "unavailable" keyword
  elif nmcli device | grep 'wifi' -q | awk '$3 == "unavailable" { print $3 }' == "unavailable"; then
      echo "$(date): No connected device found on $USB_PATH" >> "$LOG_FILE"
  else
      echo "$(date): A connected device was found." >> "$LOG_FILE"
  fi
  sleep 120 # Wait for 2 minutes
done