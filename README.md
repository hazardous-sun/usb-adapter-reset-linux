# USB Reset

This script was developed as a workaround for a USB Wi-Fi adapter that was not working properly and got back to work when disconnected and reconnected.

**Only tested on GNU/Linux Debian based distros.

### Configuration

The bash script checks for a specified USB device name that can be edited in the variable CURRENT_USB_BUS and CURRENT_USB_PORT inside [wifi_check.sh](wifi_check.sh).

You can add the script to the list of processes that boot with the computer using the following steps:

Insert the following code inside `/etc/systemd/system/wifi_reset.service`:

```
[Unit]
Description=Wi-Fi Reset Script

[Service]
ExecStart=/path/to/your/script.sh
Restart=always
User=root

[Install]
WantedBy=default.target
```

Now enable and add the script to the boot list:

```
sudo systemctl enable wifi_reset.service
sudo systemctl start wifi_reset.service
```

Check if it is running smoothly with the following command:

```
sudo systemctl status wifi_reset.service
```

Finally, remember to reboot the computer afterward to ensure it was correctly added to the booting processes list.