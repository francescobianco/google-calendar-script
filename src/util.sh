
google_calendar_script_date() {
  local offset

  offset=$1

  if [ -n "${offset}" ]; then
      if [ "$(uname)" == "Darwin" ]; then
        offset=$(echo "$offset" | sed 's/.*\([+-][0-9]*\) *\([a-z]\).*/\1\2/g' | tr 'hms' 'HMS')
        date -u -j -v${offset} +"%Y-%m-%dT%H:%M:%SZ"
      else
        date -u -d "${offset}" +"%Y-%m-%dT%H:%M:%SZ"
      fi
  else
    date -u +"%Y-%m-%dT%H:%M:%SZ"
  fi
}

google_calendar_script_date_timestamp() {
  local date

  date=$1

  if [ "$(uname)" == "Darwin" ]; then
    date -j -f "%Y-%m-%dT%H:%M:%S" "${date:0:19}" +"%s"
  else
    date -d "$date" +"%s"
  fi
}

google_calendar_script_file_timestamp() {
  local file

  file=$1

  if [ "$(uname)" == "Darwin" ]; then
    stat -f %m "${file}"
  else
    stat -c %Y "${file}"
  fi
}
