#!/bin/bash

# Run nmcli command and check for "disconnected" keyword
if nmcli device | grep -q "disconnected"; then
    echo "No connected device found. Running usb_reset..."
    ./usb_reset "/dev/bus/usb/001/006"
else
    echo "A connected device was found."
fi
