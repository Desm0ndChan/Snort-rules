#!/bin/bash
INTERFACE="enp0s8"
ALARM_MODE="console"

# Check if the promisc mode enabled
/usr/sbin/ip link show $INTERFACE | /usr/bin/grep -q promisc && /usr/bin/echo "Promiscuous mode is enabled" || /usr/bin/echo "Promiscuous mode is disabled"
if [ $? -ne 0 ] ; then
    echo "Promiscuous mode is disabled, enabling now"
    /usr/sbin/ip link set $INTERFACE promisc on
fi

echo "Checking the config file"

# Check if the config file exists
if [ ! -e /etc/snort/snort.conf ] ; then
    echo "No Snort config file found!"
    exit 1
fi
# Check if the config file is valid
/usr/sbin/snort -T -i $INTERFACE -c /etc/snort/snort.conf
if [ $? -ne 0 ] ; then
    echo "Snort exited with an error!"
    exit 1
fi
echo "Done"

echo "Starting Snort"
/usr/sbin/snort -A $ALARM_MODE -i $INTERFACE -c /etc/snort/snort.conf