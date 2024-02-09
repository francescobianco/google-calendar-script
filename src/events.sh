
google_calendar_script_events() {
  local cache_file
  local access_token_file
  local script_file
  local current_time
  local last_modified
  local expiring_time

  cache_file=$1
  script_file=$2
  access_token_file=$3

  current_time=$(date +%s)
  if [ -f "${cache_file}" ]; then
    last_modified=$(google_calendar_script_file_timestamp "${cache_file}")
  else
    last_modified=0
    echo "## Cache file of google-calendar-script" > "${cache_file}"
  fi
  expiring_time=$((current_time - last_modified))

  #echo "E: $expiring_time $current_time $last_modified"

  if [ "${expiring_time}" -gt "1800" ]; then
    echo "Refreshing events..."
    google_calendar_script_refresh_events "${cache_file}" "${access_token_file}"
  fi

  #cat "${cache_file}"

  cp "${cache_file}" "${cache_file}.1"
  grep '^EVENT ' "${cache_file}.1" | while read -r line; do
    #echo "Processing: $line"
    google_calendar_script_parse_event "$cache_file" "$script_file" "$line"
  done

  rm "${cache_file}.1"
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

  grep '^EVENT' "${cache_file}" > "${cache_file}.0" && true

  temp_file=$(mktemp)
  sed '/^EVENT/d' "${cache_file}" > "${temp_file}"
  mv "${temp_file}" "${cache_file}"

  time_min=$(google_calendar_script_date "-12 hours")
  time_max=$(google_calendar_script_date "+12 hours")

  events_query="timeMin=$time_min&timeMax=$time_max&singleEvents=true&orderBy=startTime"
  calendar_list=$(curl -s -X GET -H "Authorization: Bearer $access_token" "https://www.googleapis.com/calendar/v3/users/me/calendarList")

   echo "$calendar_list" \
    | jq -r '.items[] | "\(.id) \(.defaultReminders[0].minutes//0) \(.defaultReminders[1].minutes//0)"' \
    | while read -r calendar; do
        calendar_id=$(echo "$calendar" | cut -d' ' -f1)
        default_reminder_1=$(echo "$calendar" | cut -d' ' -f2)
        default_reminder_2=$(echo "$calendar" | cut -d' ' -f3)

        #echo "Found calendar $calendar_id"

        calendar_events=$(curl -s -X GET -H "Authorization: Bearer $access_token" \
            "https://www.googleapis.com/calendar/v3/calendars/$calendar_id/events?$events_query")

        echo "$calendar_events" \
          | jq -r '.items[] | "EVENT \(.id) '"$calendar_id"' \(.start.dateTime) \(.end.dateTime) \(.reminders.overrides[0].minutes//'"${default_reminder_1}"') \(.reminders.overrides[1].minutes//'"${default_reminder_2}"') \(.summary)"' \
          | while read -r line; do
              event_id=$(echo "$line" | cut -d' ' -f2)
              event_data=$(echo "$line" | cut -d' ' -f3-)
              event_state=$(grep "^EVENT $event_id" "${cache_file}.0" | cut -d' ' -f3)
              echo "EVENT ${event_id} ${event_state:-UNKNOWN} ${event_data}" >> "${cache_file}"
            done
      done

  rm -f "${cache_file}.0"
}

google_calendar_script_parse_event() {
  local cache_file
  local script_file
  local event
  local event_id
  local event_state
  local event_data
  local event_start
  local event_end
  local event_reminder_1
  local event_reminder_2
  local event_summary
  local current_time
  local current_date

  cache_file=$1
  script_file=$2
  event=$3

  event_id=$(echo "$event" | cut -d' ' -f2)
  event_state=$(echo "$event" | cut -d' ' -f3)

  if [ "$event_state" != "ENDED" ]; then
    event_start=$(echo "$event" | cut -d' ' -f5)
    event_end=$(echo "$event" | cut -d' ' -f6)
    event_reminder_1=$(echo "$event" | cut -d' ' -f7)
    event_reminder_2=$(echo "$event" | cut -d' ' -f8)
    event_summary=$(echo "$event" | cut -d' ' -f9-)

    echo -e "Processing: '$event_summary'"

    update_state=${event_state}
    current_time=$(date +%s)
    current_date=$(google_calendar_script_date "${current_time}")

    #echo "S: $event_start E: $event_end R1: $event_reminder_1 R2: $event_reminder_2"
    start_time=$(google_calendar_script_date_timestamp "$event_start")
    end_time=$(google_calendar_script_date_timestamp "$event_end")
    reminder_1_time=$((start_time - event_reminder_1 * 60))
    reminder_2_time=$((start_time - event_reminder_2 * 60))

    #echo "END $current_time $end_time"
    #echo "START $current_time $start_time"
    #echo "REMINDER1 $current_time $reminder_1_time"

    if [ "$current_time" -lt "$start_time" ]; then
      update_state="PENDING"
    fi

    if [ "$current_time" -gt "$reminder_2_time" ]; then
      update_state="REMINDED1"
    fi

    if [ "$current_time" -gt "$reminder_1_time" ]; then
      update_state="REMINDED2"
    fi

    if [ "$current_time" -gt "$start_time" ]; then
      update_state="STARTED"
    fi

    if [ "$current_time" -gt "$end_time" ]; then
      update_state="ENDED"
    fi

    if [ "$update_state" != "$event_state" ]; then
      echo "Updating state of '${event_summary}' from $event_state to $update_state"

      temp_file="$(mktemp)"
      sed 's/^EVENT '"${event_id}"' [A-Z]* /EVENT '"${event_id}"' '"${update_state}"' /g' "${cache_file}" > "${temp_file}"
      mv "${temp_file}" "${cache_file}"

      if [ "${update_state}" != "PENDING" ]; then
        export GOOGLE_CALENDAR_EVENT_ID="${event_id}"
        export GOOGLE_CALENDAR_EVENT_STATE="${update_state}"
        export GOOGLE_CALENDAR_EVENT_STATE_TIME="${current_date}"
        export GOOGLE_CALENDAR_EVENT_SUMMARY="${event_summary}"
        export GOOGLE_CALENDAR_EVENT_START="${event_start}"
        export GOOGLE_CALENDAR_EVENT_END="${event_end}"
        export GOOGLE_CALENDAR_EVENT_REMINDER_1="${event_reminder_1}"
        export GOOGLE_CALENDAR_EVENT_REMINDER_2="${event_reminder_2}"
        /bin/bash -x "${script_file}"
      else
        echo "Skipping event, it is still pending."
      fi
    fi

    #echo "EVENT $event_id $event_state $event_start $event_end $event_reminder_1 $event_reminder_2 $event_summary"
  fi
}
