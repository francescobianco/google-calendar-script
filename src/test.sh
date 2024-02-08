

google_calendar_script_test() {
  local event_state
  local script_file

  event_state=${1:-STARTED}
  script_file=${2:-"${HOME}/.google/calendar-script.sh"}
  test_db_file=$(mktemp)

  case $event_state in
    STARTED)
      event_start=$(google_calendar_script_date "-5 minutes")
      event_end=$(google_calendar_script_date "+1 hour")
      ;;
    ENDED)
      event_start=$(google_calendar_script_date "-2 hours")
      event_end=$(google_calendar_script_date "-1 hour")
      ;;
    *)
      echo "Invalid state '${event_state}'"
      exit 1
      ;;
  esac

  echo "Testing '${event_state}' state on fake event"
  echo "EVENT ID UNKNOWN CALENDAR $event_start $event_end 5 10 Fake Calendar Event" > "${test_db_file}"
  google_calendar_script_events "${test_db_file}" "${script_file}"
  rm -f "${test_db_file}"
}
