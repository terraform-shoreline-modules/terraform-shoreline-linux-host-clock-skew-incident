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