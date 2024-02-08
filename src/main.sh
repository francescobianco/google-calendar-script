
module auth
module events
module date
module test

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

  case $command in
    --help|-h)
      usage
      ;;
    --cron)
      google_calendar_script_auth "${access_token_file}" "${client_secret_file}"
      google_calendar_script_events "${db_file}" "${script_file}" "${access_token_file}"
      ;;
    --sync)
      google_calendar_script_auth "${access_token_file}" "${client_secret_file}"
      google_calendar_script_events "${db_file}" "${script_file}" "${access_token_file}"
      ;;
    --auth)
      google_calendar_script_auth "${access_token_file}" "${client_secret_file}"
      ;;
    --edit)
      nano "${script_file}"
      ;;
    --info)
      echo "==[DATABASE: '${db_file}']=="
      sed '/^#/d' "${db_file}"
      echo "==[END]=="
      echo
      echo "==[SCRIPT: '${script_file}']=="
      sed -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${script_file}"
      echo "==[END]=="
      ;;
    --test)
      event_state=${2:-STARTED}
      google_calendar_script_test "${event_state}" "${script_file}"
      ;;
    *)
      usage
      ;;
  esac
}
