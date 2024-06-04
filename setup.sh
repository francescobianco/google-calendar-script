#!/usr/bin/env sh
set -e

PREFIX=${1:-${HOME}/.mush/bin}
CRONJOB="* * * * * ${PREFIX}/google-calendar-script --cron"

if ! crontab -l 2>/dev/null | grep -F "$CRONJOB" >/dev/null 2>&1; then
  (crontab -l 2>/dev/null; echo "$CRONJOB") | crontab -
fi
