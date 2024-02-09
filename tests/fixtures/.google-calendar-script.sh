#!/usr/bin/env bash

echo "GOOGLE_CALENDAR_EVENT_ID: ${GOOGLE_CALENDAR_EVENT_ID}"
echo "GOOGLE_CALENDAR_EVENT_SUMMARY: ${GOOGLE_CALENDAR_EVENT_SUMMARY}"
echo "GOOGLE_CALENDAR_EVENT_STATE: ${GOOGLE_CALENDAR_EVENT_STATE}"

echo "${GOOGLE_CALENDAR_EVENT_STATE_TIME} ${GOOGLE_CALENDAR_EVENT_START} ${GOOGLE_CALENDAR_EVENT_END} [$GOOGLE_CALENDAR_EVENT_STATE] - $GOOGLE_CALENDAR_EVENT_SUMMARY" >> "${HOME}/.google/calendar-script.log"

sanitize_utf8() {
  local text
  local regex

  text="$1"
  regex='[^[:alnum:][:space:][:punct:]]'

  echo "$text" | LC_CTYPE=C sed -e "s/$regex//g"
}

## Push a notification to LINE chat (read more: <https://github.com/francescobianco/linepush>)
linepush "$(sanitize_utf8 "${GOOGLE_CALENDAR_EVENT_SUMMARY}")"

## Set OneThing message on display (read more: <https://github.com/francescobianco/one-thing>)
one-thing "${GOOGLE_CALENDAR_EVENT_STATE}: ${GOOGLE_CALENDAR_EVENT_SUMMARY}"
