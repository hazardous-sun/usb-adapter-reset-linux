#!/bin/bash

# Checks if the script ran as superuser
if ! [[ "$EUID" = 0 ]]; then
  echo "You need to run the code as superuser. Don't worry, everything that it is doing is well documented. :)"
  exit 1
fi

# Gets the current path of the script
SCRIPT_DIR=$(dirname "$0")

gcc "$SCRIPT_DIR/usb_reset.c" -o usb_reset

# Tries to get the path of the manual reset script
SHORTCUT_MANUAL_SCRIPT="$SCRIPT_DIR/adapter_reset.sh"

# Triggers if "adapter_reset.sh" is present
if test -f "$SHORTCUT_MANUAL_SCRIPT"; then
  # Adds the manual reset script to the CLI
  cp SHORTCUT_MANUAL_SCRIPT /bin/
  echo "Manual adapter reset added to the CLI"
fi

# Triggers if a path was provided
if test -f "$1"; then
  PROJECT_PATH="$1/wifi_check_adapter_reset"
  echo "Path used by the project: $PROJECT_PATH"
else
  # Sets "/home/USER/wifi_check_adapter_reset" as path
  PROJECT_PATH="$HOME/wifi_check_adapter_reset"
  echo "Path used by the project: $PROJECT_PATH"
fi

# Creates the "wifi_check_adapter_reset" directory that will be used to store the scripts and log files
mkdir "$PROJECT_PATH"

# Copies wifi_check.sh, reduce_log.sh, usb_reset and README.md to "$PROJECT_PATH"
cp wifi_check.sh reduce_log.sh usb_reset README.md "$PROJECT_PATH"

# Gets the path of the script inside "$PROJECT_PATH"
PROGRAM_PATH="$PROJECT_PATH/wifi_check.sh"

# The path to the ".service" file that will be created
SERVICE_FILE="/etc/systemd/system/wifi_reset.service"

# Triggers if the ".service" file does not exist
if ! test -f "$SERVICE_FILE"; then
  sudo touch "$SERVICE_FILE"
fi

# Clear the content of the ".service" file
sudo truncate -s 0 "$SERVICE_FILE"

# Paste inside the ".service" file the content used to set wifi_check.sh as a boot process
sudo printf "[Unit]\nDescription=Description=Wi-Fi Reset Script\n\n[Service]\nExecStart=%s\nRestart=always\nUser=root\n\n[Install]\nWantedBy=default.target", "$PROGRAM_PATH" >> "$SERVICE_FILE"

# Enables the ".service" file
sudo systemctl enable wifi_reset.service

# Starts the ".service" file
sudo systemctl start wifi_reset.service

echo "All done, now you just need to reboot your system in order to apply the changes made."