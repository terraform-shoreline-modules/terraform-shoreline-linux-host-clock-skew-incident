
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host Clock Skew Incident
---

A host clock skew incident occurs when there is a discrepancy between the system clock of a host and the actual time. This can lead to issues with timestamps and synchronization between different systems. This incident type often requires investigation and resolution of the underlying clock synchronization issue.

### Parameters
```shell
export NTP_SERVER_IP_ADDRESS="PLACEHOLDER"

export EXPECTED_TIMEZONE="PLACEHOLDER"

export NTP_SERVER_IP="PLACEHOLDER"
```

## Debug

### Check the current system time
```shell
date
```

### Check the time settings of the host
```shell
timedatectl
```

### Check the NTP status and configuration
```shell
systemctl status ntp

grep -v ^# /etc/ntp.conf
```

### Check the NTP peers and their synchronization status
```shell
ntpq -p
```

### Force NTP time synchronization
```shell
sudo systemctl stop ntp

sudo ntpd -gq

sudo systemctl start ntp
```

### Check the system logs for time-related issues
```shell
journalctl -u ntp
```

### Misconfigured Network Time Protocol (NTP) server on the host, leading to incorrect synchronization of time.
```shell
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


```

### Incorrect system time zone settings on the host.
```shell
bash

#!/bin/bash



# Get the current system time

current_time=$(date +%Y-%m-%d\ %H:%M:%S)



# Get the current system time zone

current_timezone=$(date +%Z)



# Get the expected system time zone

expected_timezone=${EXPECTED_TIMEZONE}



# Compare the current and expected time zones

if [ "$current_timezone" != "$expected_timezone" ]; then

  echo "ERROR: System time zone is incorrect. Current time zone is $current_timezone, but expected time zone is $expected_timezone."

  echo "Current time is $current_time"

else

  echo "SUCCESS: System time zone is correct."

fi


```

## Repair

### Verify that the Network Time Protocol (NTP) service is running and properly configured on the affected host(s). If NTP is not installed, install and configure it.
```shell


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


```

### Set server to the correct time zone
```shell


#!/bin/bash



# Set the time zone

sudo timedatectl set-timezone ${EXPECTED_TIME_ZONE}



# Verify the time zone has been set correctly

timedatectl


```