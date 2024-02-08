

google_calendar_script_test() {
  local event_state
  local script_file

  event_state=${1:-STARTED}
  script_file=${2:-"${HOME}/.google/calendar-script.sh"}

  echo "Testing '${event_state}' state on fake event"
  test_db_file=$(mktemp)
  case $event_state in
    STARTED)
      event_start=$(google_calendar_script_date "-5 minutes")
      event_end=$(google_calendar_script_date "+1 hour")
      ;;
    FINISHED)
      event_start=2020-01-01T00:00:00Z
      event_end=2020-01-01T01:00:00Z
      ;;
    *)
      echo "Invalid state"
      exit 1
      ;;
  esac
  echo "EVENT ID UNKNOWN CALENDAR $event_start $event_end 5 10 Fake Calendar Event" > "${test_db_file}"
  google_calendar_script_events "${test_db_file}" "${script_file}"
  rm -f "${test_db_file}"
}
