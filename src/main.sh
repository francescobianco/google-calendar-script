
module auth
module events
module test
module util

usage() {
  echo "Usage: google-calendar-script --sync"
  echo "       google-calendar-script --auth"
}

main() {
  local command
  local access_token_file
  local client_secret_file
  local event_state

  command=$1
  access_token_file="${HOME}/.google/access_token.json"
  client_secret_file="${HOME}/.google/client_secret.json"
  db_file="${HOME}/.google/calendar-script.db"
  script_file="${HOME}/.google/calendar-script.sh"
  log_file="${HOME}/.google/calendar-script.log"

  case $command in
    --help|-h)
      usage
      ;;
    --cron)
      echo "==> $(date +"%Y-%m-%d %H:%M:%S")" >> "${log_file}"
      google_calendar_script_auth \
        "${access_token_file}" "${client_secret_file}" >> "${log_file}" 2>&1
      google_calendar_script_events \
        "${db_file}" "${script_file}" "${access_token_file}" 1800 >> "${log_file}" 2>&1
      ;;
    --sync)
      google_calendar_script_auth "${access_token_file}" "${client_secret_file}" interactive
      google_calendar_script_events "${db_file}" "${script_file}" "${access_token_file}" 1
      ;;
    --auth)
      google_calendar_script_auth "${access_token_file}" "${client_secret_file}"
      ;;
    --edit)
      nano "${script_file}"
      ;;
    --info)
      echo "==> Events: '${db_file}'"
      sed '/^#/d' "${db_file}"
      echo "[EOF]"
      echo
      echo "==> Script: '${script_file}'"
      sed -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${script_file}"
      echo "[EOF]"
      ;;
    --test)
      event_state=${2:-STARTED}
      google_calendar_script_test "${event_state}" "${script_file}"
      ;;
    --logs)
      tail -f "${log_file}"
      ;;
    *)
      usage
      ;;
  esac
}
