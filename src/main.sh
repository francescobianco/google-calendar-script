
module auth
module events

usage() {
  echo "Usage: google-calendar-script --sync"
  echo "       google-calendar-script --auth"
}

main() {
  local command
  local access_token_file
  local client_secret_file

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
      google_calendar_script_events "${db_file}" "${access_token_file}" "${script_file}"
      ;;
    --sync)
      google_calendar_script_events "${db_file}" "${access_token_file}" "${script_file}"
      ;;
    --auth)
      google_calendar_script_auth "${access_token_file}" "${client_secret_file}"
      ;;
  esac
}
