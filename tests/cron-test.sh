#!/bin/bash
set -e

access_token_file="${HOME}/.google/access_token.json"
db_file="${HOME}/.google/calendar-script.db"
log_file="${HOME}/.google/calendar-script.log"

#rm -f "${access_token_file}"
#rm -f "${db_file}"
#rm -f "${log_file}"

mush run -- --cron && true

echo
echo "====[ Output ]===="
cat "${log_file}"