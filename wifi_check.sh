#!/bin/bash

while true; do

  # Define paths
  SCRIPT_DIR=$(dirname "$0")
  USB_RESET_SCRIPT="$SCRIPT_DIR/usb_reset"

  # Replace "RTL88x2bu" with the name of the device you want to reset
  CURRENT_USB_BUS=$(lsusb | grep RTL88x2bu | awk '{print $2}')
  CURRENT_USB_PORT=$(lsusb | grep RTL88x2bu | awk '{print $4}')

  USB_PATH="/dev/bus/usb/$CURRENT_USB_BUS/$CURRENT_USB_PORT"
  LOG_FILE="$SCRIPT_DIR/reset_script.log"
  LOG_REDUCE_SCRIPT="$SCRIPT_DIR/reduce_log.sh"

  # Get WiFi device status | Replace "wlx90de80ae8d61" with the name of your Wi-Fi adapter
  wifi_status=$(nmcli device show wlx90de80ae8d61 | awk -F": " '/GENERAL.STATE/ {gsub(/^[ \t]+|[()0-9]+/,"",$2); sub(/^[ \t]+/, "", $2); print $2}')

  if [ "$wifi_status" == "connected" ]; then
    echo "$(date): A WiFi device was found and is connected." >> "$LOG_FILE"
  elif [ "$wifi_status" == "disconnected" ]; then
    echo "$(date): A WiFi device was found, but it is disconnected. Running usb_reset..." >> "$LOG_FILE"
    echo "CURRENT_USB_BUS=$CURRENT_USB_BUS | CURRENT_USB_PORT=$CURRENT_USB_PORT"
    "$USB_RESET_SCRIPT" "$USB_PATH"
    case $? in
          0) echo "$(date): Reset successful" >> "$LOG_FILE" ;;
          1) echo "$(date): ERROR no path provided" >> "$LOG_FILE" ;;
          2) echo "$(date): ERROR on opening output file" >> "$LOG_FILE" ;;
          3) echo "$(date): ERROR in ioctl" >> "$LOG_FILE" ;;
          *) echo "$(date): Unknown error occurred" >> "$LOG_FILE" ;;
    esac
  else
    echo "$(date): No WiFi device found on $USB_PATH" >> "$LOG_FILE"
  fi

  LINES_TO_REMOVE=615
  bash "$LOG_REDUCE_SCRIPT" "$LINES_TO_REMOVE" "$LOG_FILE" # LINES_TO_REMOVE needs to be passed with the script
  case $? in
    0) echo "Log file size is not larger than 100 KB." ;;
    1) echo "Log file $LOG_FILE not found." ;;
    2) echo "$(date): Removed the first $LINES_TO_REMOVE lines from $LOG_FILE" >> "$LOG_FILE" ;;
    *) echo "$(date): Unknown error occurred" >> "$LOG_FILE" ;;
  esac

  sleep 120 # Wait for 2 minutes
done
