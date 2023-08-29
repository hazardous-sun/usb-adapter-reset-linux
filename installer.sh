#!/bin/bash

# Checks if the script ran as superuser
if ! [[ "$EUID" = 0 ]]; then
  echo "You need to run the code as superuser. Don't worry, everything that it is doing is well documented. :)"
  exit 1
fi

# Gets the current path of the script
SCRIPT_DIR=$(dirname "$0")

# Tries to get the path of the manual reset script
SHORTCUT_MANUAL_SCRIPT="$SCRIPT_DIR/adapter_reset.sh"

# Triggers if "adapter_reset.sh" is present
if test -f "$SHORTCUT_MANUAL_SCRIPT"; then
  # Adds the manual reset script to the CLI
  cp SHORTCUT_MANUAL_SCRIPT /bin/
fi

# Triggers if a path was provided
if test -f "$1"; then
  PROJECT_PATH="$1/wifi_check_adapter_reset"
else
  PROJECT_PATH="$HOME/wifi_check_adapter_reset"
fi

# Creates the "wifi_check_adapter_reset" directory that will be used to store the scripts and log files
mkdir "$PROJECT_PATH"

# Gets the path of the
PROGRAM_PATH="$PROJECT_PATH/wifi_check.sh"

SERVICE_FILE="/etc/systemd/system/wifi_reset.service"

if ! test -f "$SERVICE_FILE"; then
  sudo touch "$SERVICE_FILE"
fi
sudo truncate -s 0 "$SERVICE_FILE"
sudo printf "[Unit]\nDescription=Description=Wi-Fi Reset Script\n\n[Service]\nExecStart=%s\nRestart=always\nUser=root\n\n[Install]\nWantedBy=default.target", "$PROGRAM_PATH" >> "$SERVICE_FILE"

sudo systemctl enable wifi_reset.service
sudo systemctl start wifi_reset.service

echo "All done, now you just need to reboot your system in order to apply the changes made."