#!/bin/bash

# Define the command to be run by the cronjob
COMMAND="/home/ec2-user/hr/backup.sh"

# Create a new cronjob that runs at 4pm every day
(crontab -l ; echo "0 16 * * * $COMMAND") | crontab -
