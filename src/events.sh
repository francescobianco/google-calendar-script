
google_calendar_script_events() {
  local cache_file
  local access_token_file
  local access_token
  local calendar_ids
  local calendar_id
  local today
  local tomorrow
  local events_query

  cache_file=$1

  current_time=$(date +%s)
  if [ -f "${cache_file}" ]; then
    last_modified=$(stat -c %Y "${cache_file}")
  else
    last_modified=0
  fi
  expiring_time=$((current_time - last_modified))

  echo "E: $expiring_time $current_time $last_modified"

  if [ "${expiring_time}" -gt "30" ]; then
    access_token_file=$2
    access_token=$(sed -n 's/.*"access_token": *"\(.*\)".*/\1/p' "${access_token_file}" | cut -d '"' -f 1)

    echo "## Cache file of google-calendar-script" > "${cache_file}"

    today=$(date -u +"%Y-%m-%dT00:00:00Z")
    if [ "$(uname)" == "Darwin" ]; then
        tomorrow=$(date -u -j -v+1d -f "%Y-%m-%dT%H:%M:%SZ" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "+%Y-%m-%dT00:00:00Z")
    else
        tomorrow=$(date -u -d "tomorrow" +"%Y-%m-%dT00:00:00Z")
    fi

    calendar_ids=$(curl -s -X GET -H "Authorization: Bearer $access_token" "https://www.googleapis.com/calendar/v3/users/me/calendarList"  | jq -r '.items[].id')
    events_query="timeMin=$today&timeMax=$tomorrow&singleEvents=true&orderBy=startTime"

    for calendar_id in $calendar_ids; do
      curl -s -X GET -H "Authorization: Bearer $access_token" \
        "https://www.googleapis.com/calendar/v3/calendars/$calendar_id/events?$events_query" \
          | jq -r '.items[] | "EVENT '"$calendar_id"' \(.start.dateTime) \(.end.dateTime) \(.summary)"' >> "${cache_file}"
    done
  fi
}
