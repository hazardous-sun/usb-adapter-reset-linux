#!/bin/bash

# Replace "RTL88x2bu" with the name of the device you want to reset
CURRENT_USB_BUS=$(lsusb | grep RTL88x2bu | awk '{print $2}')
CURRENT_USB_PORT=$(lsusb | grep RTL88x2bu | awk '{print $4}')

./cli_usb_reset "$CURRENT_USB_BUS", "$CURRENT_USB_PORT"
