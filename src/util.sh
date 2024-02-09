
google_calendar_script_date() {
  local offset
  local sign
  local format

  offset=$1
  sign=${offset:0:1}
  format="%Y-%m-%dT%H:%M:%SZ"

  if [ -z "${offset}" ]; then
    date -u +"${format}"
  elif [ "${sign}" == "+" ] || [ "${sign}" == "-" ]; then
    if [ "$(uname)" == "Darwin" ]; then
      offset=$(echo "$offset" | sed 's/.*\([+-][0-9]*\) *\([a-z]\).*/\1\2/g' | tr 'hms' 'HMS')
      date -u -j -v"${offset}" +"${format}"
    else
      date -u -d "${offset}" +"${format}"
    fi
  else
    if [ "$(uname)" == "Darwin" ]; then
      date -r "${offset}" +"${format}"
    else
      date -d "@${offset}" +"${format}"
    fi
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
