

#!/bin/bash



# Set the time zone

sudo timedatectl set-timezone ${EXPECTED_TIME_ZONE}



# Verify the time zone has been set correctly

timedatectl