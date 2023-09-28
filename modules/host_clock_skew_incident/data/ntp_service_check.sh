

#!/bin/bash



# Check if NTP service is running

systemctl is-active --quiet ntpd

if [ $? -eq 0 ]; then

    echo "NTP service is already running."

else

    # Install NTP if it is not installed

    if ! dpkg -s ntp > /dev/null 2>&1 ; then

        apt-get update

        apt-get install ntp -y

    fi



    # Configure NTP

    sed -i 's/^pool/#pool/' /etc/ntp.conf

    echo "server ${NTP_SERVER_IP}" >> /etc/ntp.conf



    # Restart NTP service

    systemctl restart ntpd

    echo "NTP service has been restarted."

fi