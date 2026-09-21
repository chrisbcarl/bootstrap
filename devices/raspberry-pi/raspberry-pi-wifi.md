# Wireless WiFi
- [guide](https://ra-electronics.com/connect-raspberry-pi-to-wifi-cli/)
- command overview

```bash
sudo apt install wireless-tools -y                  # iwconfig
sudo apt install net-tools -y                       # ifconfig
iwconfig                                            # list the devices you have
sudo iwlist wlan0 scan | grep ESSID                 # scan for networks
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf   # edit config
sudo wpa_cli -i wlan0 reconfigure                   # restart
ifconfig wlan0                                      #
ping -c 4 google.com                                # external test
```

- `/etc/wpa_supplicant/wpa_supplicant.conf`
    ```ini
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=US
    network={
        ssid="Your_SSID"
        psk="Your_Password"
        key_mgmt=WPA-PSK
    }
    ```
