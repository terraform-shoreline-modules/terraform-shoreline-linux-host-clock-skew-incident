bash

#!/bin/bash



# Check if NTP service is running

if ! systemctl is-active ntpd > /dev/null; then

    echo "NTP service is not running."

    exit 1

fi



# Check NTP server configuration

if ! grep -q "^server ${NTP_SERVER_IP_ADDRESS}" /etc/ntp.conf; then

    echo "NTP server is not configured correctly."

    exit 1

fi



# Check if NTP server is reachable

if ! ntpdate -q ${NTP_SERVER_IP_ADDRESS} > /dev/null; then

    echo "Unable to reach NTP server."

    exit 1

fi



echo "NTP server is configured and reachable."

exit 0