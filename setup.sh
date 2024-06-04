#!/usr/bin/env sh
set -e

cron_job="* * * * * google-calendar-script"
crontab -l | grep -F "$cron_job" >/dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "The cron job already exists."
else
  # Add the cron job
  (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
  echo "Cron job added successfully."
fi

## Install crontab
(crontab -l 2>/dev/null; echo "* * * * * google-calendar-script") | crontab -
