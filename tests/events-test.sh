#!/bin/bash

source src/events.sh

cache_file="tests/tmp/.google-calendar-script.cache"
access_token_file="tests/tmp/access_token.json"

#rm -fr "${cache_file}"

google_calendar_script_events "${cache_file}" "${access_token_file}"

#cat "${cache_file}"
