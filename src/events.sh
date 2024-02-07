
google_calendar_script_events() {
  local cache_file
  local access_token_file
  local current_time
  local last_modified
  local expiring_time

  cache_file=$1
  access_token_file=$2

  current_time=$(date +%s)
  if [ -f "${cache_file}" ]; then
    last_modified=$(stat -c %Y "${cache_file}")
  else
    last_modified=0
    echo "## Cache file of google-calendar-script" > "${cache_file}"
  fi
  expiring_time=$((current_time - last_modified))

  echo "E: $expiring_time $current_time $last_modified"

  if [ "${expiring_time}" -gt "5" ]; then
    google_calendar_script_refresh_events "${cache_file}" "${access_token_file}"
  fi

  #cat "${cache_file}"

  while read -r line; do
    echo "Processing $line"
  done < "${cache_file}"
}

google_calendar_script_refresh_events() {
  local cache_file
  local access_token_file
  local access_token
  local calendar_ids
  local calendar_id
  local today
  local tomorrow
  local events_query
  local temp_file

  cache_file=$1
  access_token_file=$2
  access_token=$(sed -n 's/.*"access_token": *"\(.*\)".*/\1/p' "${access_token_file}" | cut -d '"' -f 1)

  grep '^EVENT' "${cache_file}" > "${cache_file}.events"

  temp_file=$(mktemp)
  sed '/^EVENT/d' "${cache_file}" > "${temp_file}"
  mv "${temp_file}" "${cache_file}"

  today=$(date -u +"%Y-%m-%dT00:00:00Z")
  if [ "$(uname)" == "Darwin" ]; then
      tomorrow=$(date -u -j -v+1d -f "%Y-%m-%dT%H:%M:%SZ" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "+%Y-%m-%dT00:00:00Z")
  else
      tomorrow=$(date -u -d "tomorrow" +"%Y-%m-%dT00:00:00Z")
  fi


  events_query="timeMin=$today&timeMax=$tomorrow&singleEvents=true&orderBy=startTime"

  curl -s -X GET -H "Authorization: Bearer $access_token" "https://www.googleapis.com/calendar/v3/users/me/calendarList" \
    | jq -r '.items[] | "\(.id) \(.defaultReminders[0].minutes//0) \(.defaultReminders[1].minutes//0)"' \
    | while read -r calendar; do
      calendar_id=$(echo "$calendar" | cut -d' ' -f1)
      default_reminder_1=$(echo "$calendar" | cut -d' ' -f2)
      default_reminder_2=$(echo "$calendar" | cut -d' ' -f3)


      curl -s -X GET -H "Authorization: Bearer $access_token" \
        "https://www.googleapis.com/calendar/v3/calendars/$calendar_id/events?$events_query" \
          | jq -r '.items[] | "EVENT \(.id) '"$calendar_id"' \(.start.dateTime) \(.end.dateTime) \(.reminders.overrides[0].minutes//'"${default_reminder_1}"') \(.reminders.overrides[1].minutes//'"${default_reminder_2}"') \(.summary)"' \
          | while read -r line; do
            event_id=$(echo "$line" | cut -d' ' -f2)
            event_data=$(echo "$line" | cut -d' ' -f3-)
            event_state=$(grep "^EVENT $event_id" "${cache_file}.events" | cut -d' ' -f3)
            echo "EVENT ${event_id} ${event_state:-UNKNOWN} ${event_data}" >> "${cache_file}"
          done
    done







  rm -f "${cache_file}.events"
}
