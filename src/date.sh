
google_calendar_script_today() {
  local offset

  offset=$1

  if [ -n "${offset}" ]; then
      if [ "$(uname)" == "Darwin" ]; then
        tomorrow=$(date -u -j -v+1d -f "%Y-%m-%dT%H:%M:%SZ" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "+%Y-%m-%dT00:00:00Z")
      else
        tomorrow=$(date -u -d "${offset}" +"%Y-%m-%dT00:00:00Z")
      fi
  else
    date -u +"%Y-%m-%dT00:00:00Z"
  fi
}

google_calendar_script_date() {
  local offset

  offset=$1

  if [ -n "${offset}" ]; then
      if [ "$(uname)" == "Darwin" ]; then
        date -u -j -v+1d -f "%Y-%m-%dT%H:%M:%SZ"
      else
        date -u -d "${offset}" +"%Y-%m-%dT%H:%M:%SZ"
      fi
  else
    date -u +"%Y-%m-%dT%H:%M:%SZ"
  fi
}
